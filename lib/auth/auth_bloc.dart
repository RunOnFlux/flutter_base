import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as frb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/api/model/id/id_model.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/auth/connection_status.dart';
import 'package:flutter_base/auth/providers/gitlab/gitlab_auth_provider.dart';
import 'package:flutter_base/auth/service/auth_service.dart';
import 'package:flutter_base/data/flux_user.dart';
import 'package:flutter_base/extensions/router_extension.dart';
import 'package:flutter_base/extensions/try_cast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

export 'package:firebase_auth/firebase_auth.dart'
    hide User
    show EmailAuthProvider, PhoneAuthProvider, FirebaseAuth, PhoneAuthCredential, AuthCredential;
export 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

part 'auth_data.dart';
part 'auth_events.dart';
part 'auth_state.dart';
part 'firebase_auth_process.dart';

/// whether to sign out the user if they are already signed in, generally when the
/// user presses a sign in button, despite being already signed in\
/// This is expected to never happen, but by security we sign out the user, especially
/// in test environments where we sometimes change the structure of the database
/// or the functioning of the app, which can lead to unexpected behavior
const kSignoutIfAlreadySignedIn = true;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Below are stream subscriptions that are used to listen to events from
  /// Firebase and gRPC. Throughout the app it is being paused and resumed
  /// depending on some specific operations, to prevent events from being
  /// triggered when they should not be.\
  /// The [_firebaseAuthSub] is being listened to, in order to detect when the
  /// user signs in or out, and to trigger the appropriate events.\
  StreamSubscription<frb.User?>? _firebaseAuthSub;

  frb.FirebaseAuth get _firebaseInstance {
    return frb.FirebaseAuth.instanceFor(app: Firebase.app('auth'));
  }

  final FirebaseOptions firebaseOptions;

  AuthBloc({required this.firebaseOptions}) : super(AuthState.initial()) {
    FutureOr<void> onError(_AuthErrorEvent event, emit) async {
      if (event.error.type == AuthErrorType.unknown) {
        return;
      }
      var fluxUser = state.fluxUser;
      frb.User? firebaseUser = state.firebaseUser;
      AuthError? error = event.error;
      AuthChallenge? challenge;

      if (error.type == AuthErrorType.needTwoFactorAuthentication) {
        if (state.needsTwoFactorAuthenticationConfig) {
          error = AuthError.ofType(AuthErrorType.twoFactorOTPFail);
        } else {
          challenge = const AuthChallenge(type: AuthChallengeType.twoFactorAuthentication);
          error = null;
        }
      } else if (error.type == AuthErrorType.userDisabled ||
          error.type == AuthErrorType.userNotFound ||
          error.type == AuthErrorType.noUserSignedIn) {
        /// if the user is disabled or not found, we sign out the user
        await _firebaseInstance.signOut();
        fluxUser = null;
        firebaseUser = null;
        challenge = null;
      }
      emit(AuthState(
        error: error,
        fluxUser: fluxUser,
        firebaseUser: firebaseUser,
        challenge: challenge,
      ));
    }

    on<InitializeAuthEvent>((event, emit) async {
      debugPrint('AuthBloc: init');
      await init();
      emit(state.copyWith(status: AuthConnectionStatus.done));
    });
    on<FirebaseAuthSignInEvent>(firebaseAuthSignInEvent, transformer: restartable());
    on<InternalAuthEvent>((event, emit) async {
      if (event is _InternalFirebaseSignIn) {
        debugPrint('AuthBloc: _InternalFirebaseSignIn');
        final signInEvent = state.event.as<FirebaseAuthSignInEvent>();
        debugPrint(signInEvent.toString());
        if (signInEvent is FirebaseEmailAuthEvent && signInEvent.isSignUp) {
          await restSignUp(emit, signInEvent);
        } else {
          debugPrint('AuthBloc: restSignIn');
          await restSignIn(emit, signInEvent);
        }
      } else if (event is _InternalFirebaseSignOut) {
        debugPrint('[AuthBloc] Signed out');
        emit(AuthState());
      } else if (event is _AuthErrorEvent) {
        await onError(event, emit);
      }
    }, transformer: droppable());
    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthState(status: AuthConnectionStatus.waiting, event: event));

      try {
        await _firebaseInstance.sendPasswordResetEmail(email: event.email);
        emit(AuthState(
          result: AuthResult.emailSent,
          event: event,
          status: AuthConnectionStatus.done,
        ));
      } on frb.FirebaseAuthException catch (e) {
        emit(AuthState(status: AuthConnectionStatus.done, error: AuthError.from(e), event: event));
      }
    }, transformer: droppable());

    /// used mostly to periodically check if email verification is done
    on<RefreshFirebaseUserEvent>((event, emit) async {
      if (state.loading) {
        return;
      }
      if (state.hasNoFirebaseUser) {
        return;
      }

      final firebaseUser = state.firebaseUser!;
      try {
        await firebaseUser.reload();
        final newUser = _firebaseInstance.currentUser!;
        if (newUser.emailVerified) {
          emit(
            AuthState(
              firebaseUser: newUser,
              result: AuthResult.emailVerified,
              status: AuthConnectionStatus.done,
            ),
          );
          await restSignUp(emit);
        } else {
          emit(state.copyWith(firebaseUser: newUser));
        }
      } catch (e) {
        final error = AuthError.from(e);
        emit(state.copyWith(error: error));
      }
    }, transformer: droppable());
    on<RequestEmailVerificationEvent>((event, emit) async {
      final currentUser = _firebaseInstance.currentUser;
      AuthError? error;
      final silent = event.silent;
      final lastEmailVerificationRequest = await getLastEmailVerificationRequest();
      if (lastEmailVerificationRequest != null &&
          DateTime.now().difference(lastEmailVerificationRequest).inSeconds < 60) {
        if (!silent) {
          error = AuthError.ofType(AuthErrorType.emailVerificationCooldown);
        } else {
          return;
        }
      }

      if (currentUser == null) {
        error = AuthError.ofType(AuthErrorType.noUserSignedIn);
      } else if (currentUser.emailVerified) {
        error = AuthError.ofType(AuthErrorType.emailAlreadyVerified);
      }

      try {
        String redirectUrl = Uri.base.origin;
        if (event.redirectUrl != null) {
          redirectUrl += event.redirectUrl!;
        }
        final settings = ActionCodeSettings(url: 'https://beta.cloud.runonflux.io/$redirectUrl');

        await currentUser!.sendEmailVerification(settings);
        await setLastEmailVerificationRequest(DateTime.now());
      } catch (e) {
        error = AuthError.from(e);
      }

      if (!silent) {
        emit(
          state.copyWith(
            error: error,
            result: error == null ? AuthResult.emailSent : null,
          ),
        );
      }
    }, transformer: droppable());
    on<AuthRouteEvent>(
      (event, emit) {
        emit(state.copyWith(currentRoute: () => event.route));
      },
    );
    on<UpdateFluxLoginEvent>(
      (event, emit) {
        if (event.login != null) {
          event.login!.privilegeLevel = PrivilegeLevel.fromString(event.login!.privilege) ?? PrivilegeLevel.none;
          FluxAuthLocalStorage.putFluxLogin(event.login!);
        } else {
          FluxAuthLocalStorage.deleteFluxLogin();
        }
        emit(state.copyWith(fluxLogin: () => event.login));
      },
    );
    on<SignOutEvent>(
      (event, emit) {
        FluxAuthLocalStorage.deleteFluxLogin();
        emit(state.copyWith(fluxLogin: () => null));
      },
    );
  }

  Future<void> init([Duration? timeout = const Duration(seconds: 10)]) async {
    debugPrint('Initializing Firebase');
    FirebaseApp? firebaseApp;
    AuthService.bloc = this;
    try {
      await Future.wait([FluxAuthLocalStorage.init()]);
      debugPrint(firebaseOptions.toString());
      firebaseApp = await Firebase.initializeApp(name: 'auth', options: firebaseOptions);
      debugPrint(firebaseApp.toString());
      if (kIsWeb) {
        await _firebaseInstance.setPersistence(frb.Persistence.LOCAL);
      }
      _listenToFirebaseAuthSub();

      // Check if the user is already logged into Flux
      CheckPrivilege privilege = await AuthService().checkUserLogged();
      if (privilege.privilege != PrivilegeLevel.none) {
        final FluxLogin? login = FluxAuthLocalStorage.getFluxLogin();
        if (login != null) {
          login.privilege = (privilege.privilege ?? PrivilegeLevel.none).name;
          add(UpdateFluxLoginEvent(login));
        }
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    /*if (FluxAuth.config.disableAuthentication) {
      return;
    }
    if (_initialized) {
      return;
    }
    log('\x1B[37mInitializing', name: '\x1B[37mAuthBloc');

    _initializedCompleter ??= Completer();

    try {
      await Future.wait([FluxAuthLocalStorage.init()]);

      _listenToFirebaseAuthSub();

      /// if the user is already signed in, we wait for the user to be loaded
      /// in the init method, to more easily handle the state of the app
      if (_firebaseInstance.currentUser != null) {
        await waitForAsync((p0) => p0.firebaseUser != null, timeout: timeout);
      }
      _initialized = true;
      if (state.isIdle) {
        // ignore: invalid_use_of_visible_for_testing_member
        emit(state.copyWith(status: AuthConnectionStatus.done));
      }
      _initializedCompleter!.complete();
    } catch (e) {
      _initializedCompleter!.completeError(e);
      if (e is TimeoutException) {
        _initialized = true;
      }
    }*/
  }

  FutureOr<void> ensureInitialized() async {
    if (_initializedCompleter == null) {
      await init();
    } else {
      await _initializedCompleter!.future;
    }
  }

  Completer<void>? _initializedCompleter;

  /// called when the user presses an auth button, to ensure that the potential
  /// firebase user is signed out
  FutureOr<bool> ensureSignedOut(Emitter<AuthState> emit) async {
    try {
      if (_firebaseInstance.currentUser != null) {
        if (kSignoutIfAlreadySignedIn) {
          await _firebaseInstance.signOut();
        } else {
          emit(state.copyWith(error: AuthErrorType.alreadySignedIn));
          return false;
        }
      }
    } catch (e) {
      emit(state.copyWith(error: AuthErrorType.firebaseNotInitialized));
      return false;
    }
    return true;
  }

  /// listen to the firebase auth stream to update the auth state
  void _listenToFirebaseAuthSub() {
    if (_firebaseAuthSub != null) {
      return;
    }

    String? lastUserUID;

    void listener(frb.User? user) {
      debugPrint('AuthBloc: Firebase auth state change: ${user.toString()}');
      final currentUserUID = user?.uid;
      if (lastUserUID != currentUserUID) {
        if (currentUserUID == null) {
          add(const _InternalFirebaseSignOut());
        } else {
          debugPrint('AuthBloc: User changed: ${user.toString()}');
          add(_InternalFirebaseSignIn(user!));
        }
      }
      lastUserUID = currentUserUID;
    }

    listener(_firebaseInstance.currentUser);
    debugPrint('AuthBloc: \x1B[37mListening to Firebase auth');
    _firebaseAuthSub = _firebaseInstance.authStateChanges().listen(listener);
  }

  void _pauseFirebaseAuthSub() {
    _firebaseAuthSub?.pause();
  }

  void _resumeFirebaseAuthSub() {
    _firebaseAuthSub?.resume();
  }

  Future<DateTime?> getLastEmailVerificationRequest() async {
    final int? ms = FluxAuthLocalStorage.instance.get('lastEmailVerificationRequest');
    if (ms == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  Future<void> setLastEmailVerificationRequest(DateTime dateTime) {
    return FluxAuthLocalStorage.instance.put(
      'lastEmailVerificationRequest',
      dateTime.millisecondsSinceEpoch,
    );
  }

  void setCurrentRoute(AuthFluxRoute route) {
    add(AuthRouteEvent(route));
  }
}

extension GoRouterExtension on BuildContext {
  /// check if we are on the auth branch
  bool isAuthBranch() {
    final currentRoute = currentUri;
    return currentRoute.path.startsWith(AuthFluxBranchRoute.rootPath);
  }
}

extension AuthBlocExtension on AuthBloc {
  /// called in the gRPC interceptor
  FutureOr<String?> getUserToken([bool force = false]) {
    try {
      // logger.d('[AuthBloc.getUserToken] force: $force, state: $state');
      final token = state.firebaseUser?.getIdToken(force).timeout(const Duration(seconds: 5));
      return token;
    } catch (e) {
      debugPrint('Error getting user token: $e');
      return null;
    }
  }

  FutureOr<String?> getUserTokenFromFirebaseUser({bool force = false, required User firebaseUser}) {
    try {
      // logger.d('[AuthBloc.getUserToken] force: $force, state: $state');
      final token = firebaseUser.getIdToken(force).timeout(const Duration(seconds: 5));
      return token;
    } catch (e) {
      debugPrint('Error getting user token: $e');
      return null;
    }
  }

  void signOut() {
    add(const SignOutEvent());
  }

  void disable2FA() {
    add(const TwoFactorEnableEvent(enable: false));
  }

  void updateProfile({String? displayName, String? photoURL}) {
    if (displayName == null && photoURL == null) {
      return;
    }
    add(UpdateProfileEvent(displayName: displayName, photoURL: photoURL));
  }

  void deleteUser() {
    add(const RequestDeleteAccountEvent());
  }

  Future<bool> updateUserLanguage(String languageCode) async {
    try {
      await _firebaseInstance.setLanguageCode(languageCode);
      return true;
    } catch (e) {
      return false;
    }
  }

  void goToAuthRoute(bool isPopup, BuildContext context, AuthFluxBranchRoute route) {
    if (isPopup) {
    } else {
      final router = GoRouter.of(context);
      final currentRoute = router.routerDelegate.currentConfiguration.uri;
      debugPrint(currentRoute.toString());
      final newRoute = currentRoute.replace(path: route.fullPath);
      debugPrint('goToAuthRoute: ${newRoute.toString()}');
      router.go(newRoute.toString());
    }
  }
}

abstract class FluxAuthLocalStorage {
  static Box? _instance;
  static Box get instance => _instance!;
  static Future<void> init() async {
    _instance ??= await _init();
  }

  static FutureOr<void> close() {
    if (_instance == null) {
      return Future.value();
    }
    return _instance!.close().then((value) => _instance = null);
  }

  static Future<Box> _init() {
    return Hive.openBox('flux_auth');
  }

  static String get authString {
    String zelID = Uri.encodeQueryComponent(instance.get('zelid') ?? '');
    String loginPhrase = Uri.encodeQueryComponent(instance.get('loginPhrase') ?? '');
    String signature = Uri.encodeQueryComponent(instance.get('signature') ?? '');
    String encodedAuthString = 'zelid=$zelID&signature=$signature&loginPhrase=$loginPhrase';
    return encodedAuthString;
  }

  static putFluxLogin(FluxLogin login) {
    FluxAuthLocalStorage.instance.put('zelid', login.zelid);
    FluxAuthLocalStorage.instance.put('loginPhrase', login.loginPhrase);
    FluxAuthLocalStorage.instance.put('signature', login.signature);
  }

  static deleteFluxLogin() {
    FluxAuthLocalStorage.instance.delete('zelid');
    FluxAuthLocalStorage.instance.delete('loginPhrase');
    FluxAuthLocalStorage.instance.delete('signature');
  }

  static FluxLogin? getFluxLogin() {
    final zelid = instance.get('zelid');
    final loginPhrase = instance.get('loginPhrase');
    final signature = instance.get('signature');
    if (zelid != null && loginPhrase != null && signature != null) {
      return FluxLogin(data: {
        'zelid': zelid,
        'loginPhrase': loginPhrase,
        'signature': signature,
        'message': '',
        'privilage': '',
      });
    }
    return null;
  }

  static String? get zelid => instance.get('zelid');
  static String? get loginPhrase => instance.get('loginPhrase');
  static String? get signature => instance.get('signature');
}
