part of 'auth_bloc.dart';

/// This is the state that is used by the AuthBloc\
/// It contains the current status of the authentication process, the current
/// event, the current error, the current user, and the current flux user\
/// The current user is the user that is signed in with firebase\
/// The current flux user is the user that is signed in with the flux backend\
/// The current status is the current status of the authentication process, it can be
/// idle, loading, or finished\
/// The current event is the current event that is being processed by the bloc\
/// The current error is of type [AuthErrorType] and is used to display the error to the user\
///
/// With AuthState we get all the information to update UI accordingly, two
/// instance of the state are considered equal if they have the same event, error,
/// and status, and if the delta between the two states is less than 500ms
class AuthState {
  AuthState({
    this.error,
    this.result,
    this.fluxUser,
    this.challenge,
    this.status = AuthConnectionStatus.done,
    this.event,
    this.phoneVerificationRequest,
    this.phoneSignInOTPRequest,
    this.firebaseUser,
    this.currentRoute,
    this.fluxLogin,
  }) : _timestamp = DateTime.now().millisecondsSinceEpoch;

  factory AuthState.initial() => AuthState(status: AuthConnectionStatus.idle);

  final int _timestamp; //in ms

  final AuthConnectionStatus status;
  final AuthEvent? event;
  final Object? error;
  final User? firebaseUser;
  final FluxUser? fluxUser;
  final AuthChallenge? challenge;
  final AuthResult? result;
  final PhoneSigninRequest? phoneSignInOTPRequest;
  final PhoneVerificationRequest? phoneVerificationRequest;
  final AuthFluxRoute? currentRoute;
  final FluxLogin? fluxLogin;

  AuthError? get authError {
    if (error == null) {
      return null;
    }
    return AuthError.from(error!);
  }

  bool get hasFirebaseUser => firebaseUser != null;
  bool get hasNoFirebaseUser => firebaseUser == null;

  String? get displayName {
    if (firebaseUser == null) {
      return null;
    }
    String? displayName = firebaseUser!.displayName;
    if (displayName == null || displayName.isEmpty) {
      final email = firebaseUser!.email?.split('@').firstOrNull;
      if (email != null) {
        displayName = email;
      }
    }
    return displayName ?? firebaseUser!.uid;
  }

  bool get hasError => error != null;

  /// if the user has enabled the two factor authentication
  bool get twoFactorAuthEnabled => fluxUser == null || fluxUser!.otp;

  bool get isNotAuthenticated => !isAuthenticated;

  bool get loading => status == AuthConnectionStatus.waiting;

  bool get finished => status == AuthConnectionStatus.done;

  /// The current connection status, idle is supposed to only be used
  /// at the launch of the app, it is technically similar to finished
  /// but allow to differentiate the state between the launch of the app
  /// and the end of the authentication process
  bool get isIdle => status == AuthConnectionStatus.idle;

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is AuthState) {
      final equals = other.event == event &&
          other.result == result &&
          other.phoneSignInOTPRequest == phoneSignInOTPRequest &&
          other.phoneVerificationRequest == phoneVerificationRequest &&
          other.error == error &&
          other.challenge == challenge &&
          other.fluxUser == fluxUser &&
          other.firebaseUser?.uid == firebaseUser?.uid &&
          other.currentRoute == currentRoute &&
          other.fluxLogin == fluxLogin &&
          other.status == status;
      final timeDt = _timestamp - other._timestamp;
      return equals && timeDt.abs() < 500;
    }
    return false;
  }

  /// if the user has a two factor secret and the user didn't skip the two factor authentication config
  /// meaning that the user has to configure the two factor authentication
  bool get needsTwoFactorAuthenticationConfig =>
      challenge?.type == AuthChallengeType.configureTwoFactorAuthentication && has2FAEnabled;

  bool get has2FAEnabled => fluxUser?.otp == true;

  bool get signInByPhoneProcessStarted => isNotAuthenticated && phoneSignInOTPRequest != null;
  bool get phoneVerificationProcessStarted => phoneVerificationRequest != null;

  TwoFactorConfigRequest? get twoFactorConfigRequest => challenge?.extra.as<TwoFactorConfigRequest>();
  Validate2FAOTPResult? get twoFactorOTPResult => challenge?.extra.as<Validate2FAOTPResult>();

  /// if the user has not verified his email address
  bool get needAccountVerification {
    return signedInByEmail && !firebaseUser!.emailVerified;
  }

  /// if the user is signed in by email
  bool get signedInByEmail => firebaseUser != null && signInMethods.firstOrNull == FirebaseSignInMethods.email;

  String? get email {
    if (fluxUser?.email?.isNotEmpty == true) {
      return fluxUser!.email;
    }
    if (signedInByEmail || signInMethods.any((e) => e.isProvider())) {
      return firebaseUser!.email;
    }
    return null;
  }

  // SMSValidationResult? get smsValidationResult {
  //   return extra.as<SMSValidationResult>();
  // }

  /// if the user need to pass the two factor authentication process
  /// (this can't be skipped)
  bool get needsTwoFactorAuthentication => challenge?.type == AuthChallengeType.twoFactorAuthentication;

  /// if the user need to pass the reauthentication process
  bool get needReauthentication => challenge?.type == AuthChallengeType.reauthentication;

  /// if the user is authenticated (i.e. has a flux user)
  bool get isAuthenticated => fluxUser != null;

  bool get hasChallenge => challenge != null;
  bool get hasNoChallenge => challenge == null;

  /// if the user has a non cancelable challenge to pass
  bool get hasNotCancellableChallenge {
    if (challenge == null) return false;
    return challenge!.type.skippable == false;
  }

  /// if the is authenticated and that the two factor authentication config is done or skipped
  bool get isAuthenticatedAndVerified => isAuthenticated && hasNoChallenge;

  /// whether the user is trying to disable the two factor authentication, and that he needs to pass the two factor authentication
  bool get disable2FARequested {
    final event = this.event.as<TwoFactorEnableEvent>();
    return event != null && !event.enabled;
  }

  /// whether the user is trying to delete his account, and that he needs to pass the two factor authentication
  bool get deleteAccountRequested {
    return event is RequestDeleteAccountEvent;
  }

  bool get updatingEmailRequest {
    return event is UpdateEmailEvent;
  }

  bool get actionTriggeredByUser => updatingEmailRequest || deleteAccountRequested || disable2FARequested;

  /// the list of sign in methods used by the user
  Iterable<FirebaseSignInMethods> get signInMethods {
    final signInMethods = <FirebaseSignInMethods>[];
    final providerIds = [for (final provider in firebaseUser?.providerData ?? []) provider.providerId];
    for (var id in providerIds) {
      final provider = FirebaseSignInMethods.fromProviderId(id);
      if (provider == null) continue;
      signInMethods.add(provider);
    }
    return signInMethods;
  }

  /// used to create a new instance of the state, error, and event are not kept
  /// as well as any extra of type [ExtraKeepAliveMixin] with [keepAlive] set to false
  /// Any other type of extra is kept. Meaning that if a new state is emit using copyWith
  /// the extra will still be present in the new state
  AuthState copyWith({
    AuthEvent? event,
    Object? error,
    AuthResult? result,
    ValueGetter<FluxUser?>? fluxUser,
    PhoneVerificationRequest? phoneVerificationRequest,
    PhoneSigninRequest? phoneSignInOTPRequest,
    AuthChallenge? challenge,
    AuthConnectionStatus? status,
    ValueGetter<User?>? firebaseUser,
    ValueGetter<AuthFluxRoute?>? currentRoute,
    ValueGetter<FluxLogin?>? fluxLogin,
  }) {
    return AuthState(
        challenge: challenge ?? this.challenge,
        phoneSignInOTPRequest: phoneSignInOTPRequest,
        phoneVerificationRequest: phoneVerificationRequest,
        firebaseUser: firebaseUser != null ? firebaseUser() : this.firebaseUser,
        fluxUser: fluxUser != null ? fluxUser() : this.fluxUser,
        status: status ?? this.status,
        currentRoute: currentRoute != null ? currentRoute() : this.currentRoute,
        fluxLogin: fluxLogin != null ? fluxLogin() : this.fluxLogin,
        error: error,
        event: event,
        result: result);
  }

  @override
  String toString() {
    return 'AuthState(status: $status, event: $event, error: $error, challenge: $challenge, fluxUserID: ${fluxUser?.uid}, firebaseUserID: ${firebaseUser?.uid})';
  }

  String? get photoUrl => fluxUser?.hasPhoto() == true ? fluxUser!.photo : firebaseUser?.photoURL;

  @override
  int get hashCode =>
      _timestamp.hashCode ^
      phoneVerificationRequest.hashCode ^
      event.hashCode ^
      phoneSignInOTPRequest.hashCode ^
      result.hashCode ^
      error.hashCode ^
      challenge.hashCode ^
      fluxUser.hashCode ^
      firebaseUser.hashCode ^
      status.hashCode;
}
