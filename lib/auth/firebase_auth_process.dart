part of 'auth_bloc.dart';

extension _AuthBlocExtension on AuthBloc {
  /// throw an error if the email is not associated to a Firebase Account,
  /// workaround to prevent users to be registered when not existing in Firebase
  /// when using providers
  ///
  /// Will throw [AuthErrorType.userNotFound] if the user does not exist
  ///
  /// Will create issue if the user is logged in with a provider that is not
  /// supported by Firebase namely Gitlab
  Future<void> verifyFirebaseAccountExists(frb.UserCredential userCredential) async {
    final user = userCredential.user;
    if (user == null) {
      throw AuthErrorType.userNotFound;
    }
    try {
      return _firebaseInstance.fetchSignInMethodsForEmail(user.email!).then((value) {
        if (value.isEmpty) {
          throw AuthErrorType.userNotFound;
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  /// method used to sign in with a provider, either Gitlab or Firebase supported
  /// ones
  Future<frb.UserCredential> signInWithProvider(
      AuthProvider provider, FirebaseProviderAuthEvent event, Emitter<AuthState> emit) async {
    frb.UserCredential? userCredential;
    if (!kIsWeb) {
      emit(
        AuthState(
          status: AuthConnectionStatus.waiting,
          event: event,
          currentRoute: state.currentRoute,
        ),
      );
    }

    //if (provider is GitlabAuthProvider) {
    //  userCredential = await provider.signIn();
    //} else {
    if (kIsWeb) {
      userCredential = await _firebaseInstance.signInWithPopup(provider);
    } else {
      userCredential = await _firebaseInstance.signInWithProvider(provider);
    }
    //}

    return userCredential;
  }

  /// throw an error if the email is not valid (if it is a disposable email)
  Future<void> verifyDisposableEmail(String email) async {
    /*final r = await service.isEmailValid(email);
    if (!r) {
      throw AuthErrorType.invalidDisposableEmail;
    }*/
  }

  /// method used to sign in with a provider, either Gitlab or Firebase supported
  /// and if the user already has an account, link the credential to the user
  Future<frb.UserCredential> signInOrLink(FirebaseProviderAuthEvent event, Emitter<AuthState> emit) async {
    frb.UserCredential? userCredential;

    final provider = event.provider.authProvider!;

    try {
      userCredential = await signInWithProvider(provider, event, emit);
      //if (!FluxAuth.config.enableSignUp) {
      //  await verifyFirebaseAccountExists(userCredential);
      //}
      return userCredential;
    } on frb.FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        debugPrint('\x1B[37mAccount already exists with a different credential, name: \x1B[37mAuthBloc.signInOrLink');
        final pendingCredential = e.credential;

        final email = e.email;
        debugPrint('\x1B[37mEmail: $email name: \x1B[37mAuthBloc.signInOrLink');
        final methods = await _firebaseInstance.fetchSignInMethodsForEmail(email!);
        if (methods.isEmpty) {
          /// if the user signed up with Gitlab, the provider is not returned
          /// so we need to assume that the user signed up with Gitlab
          /// to allow the user to link the account

          //methods.add(FirebaseSignInMethods.gitlab.providerId);
        }
        String? method;
        try {
          method = methods.firstWhere((e) => e != 'password' && e != 'phone' && e != 'emailLink');
        } catch (e) {
          method = null;
        }
        if (method != null) {
          _pauseFirebaseAuthSub();
          final providerType = FirebaseSignInMethods.fromProviderId(method);
          if (providerType == null) {
            throw Exception('Invalid provider type');
          }
          final providerAuthEvent = FirebaseProviderAuthEvent.fromFirebaseSignInMethods(providerType);
          frb.UserCredential userCredential;
          try {
            userCredential = await signInWithProvider(providerType.authProvider!, providerAuthEvent, emit);
          } catch (e) {
            rethrow;
          } finally {
            _resumeFirebaseAuthSub();
          }
          final user = userCredential.user;
          debugPrint('\x1B[37mFirebase user: $user, name: \x1B[37mAuthBloc.signInOrLink');
          if (user != null) {
            debugPrint('\x1B[37mLinking the credential name: \x1B[37mAuthBloc.signInOrLink');
            if (pendingCredential != null) {
              await user.linkWithCredential(pendingCredential);
            } else {
              if (kIsWeb) {
                await user.linkWithPopup(provider);
              } else {
                await user.linkWithProvider(provider);
              }
            }
          }
          return userCredential;
        }
      }
      rethrow;
    }
  }

  /// called when the user presses an auth button, to ensure that the potential
  /// firebase user is signed out
  FutureOr<bool> ensureSignedOut(Emitter<AuthState> emit) async {
    try {
      if (_firebaseInstance.currentUser != null) {
        if (kSignoutIfAlreadySignedIn) {
          await _firebaseInstance.signOut();
        } else {
          emit(state.copyWith(error: () => AuthErrorType.alreadySignedIn));
          return false;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(error: () => AuthErrorType.firebaseNotInitialized));
      return false;
    }
    return true;
  }

  void firebaseAuthSignInEvent(FirebaseAuthSignInEvent event, Emitter<AuthState> emit) async {
    debugPrint('AuthBloc: received FirebaseAuthSignInEvent');
    if (!await ensureSignedOut(emit)) {
      return;
    }
    try {
      frb.UserCredential? userCredential;
      if (event is FirebaseProviderAuthEvent) {
        userCredential = await signInOrLink(event, emit);
        final user = userCredential.user;
        if (user!.photoURL == null) {
          final o = userCredential.additionalUserInfo?.profile?['picture']?['data']?['url'];
          if (o != null) {
            await user.updatePhotoURL(o.photoURL);
          }
        }
        // if (user.providerData.isEmpty) {
        /// if the provider list is empty despite the user being signed in, it means
        /// that the user signed up with Gitlab, and that since it is not a Firebase
        /// provider, it is not returned in the list of providers, so we add it manually
        // user.providerData.add(UserInfo.);
        //TODO: add Gitlab provider
        // }
      } else if (event is FirebaseEmailAuthEvent) {
        debugPrint('AuthBloc: received FirebaseEmailAuthEvent');
        emit(
          AuthState(
            status: AuthConnectionStatus.waiting,
            event: event,
            currentRoute: state.currentRoute,
          ),
        );

        final signUp = event.isSignUp;
        if (signUp) {
          await verifyDisposableEmail(event.email);
          userCredential = await _firebaseInstance
              .createUserWithEmailAndPassword(email: event.email, password: event.password)
              .timeout(const Duration(seconds: 30));
        } else {
          userCredential = await _firebaseInstance
              .signInWithEmailAndPassword(email: event.email, password: event.password)
              .timeout(const Duration(seconds: 30));
        }
      } else if (event is FirebasePhoneAuthEvent) {
        emit(
          AuthState(
            status: AuthConnectionStatus.waiting,
            event: event,
            phoneSignInOTPRequest: event.request,
            currentRoute: state.currentRoute,
          ),
        );

        userCredential = await event.request.result.confirm(event.smsCode).timeout(
              const Duration(seconds: 30),
            );
      }
    } catch (e) {
      emit(state.copyWith(
        error: () => AuthErrorType.from(e),
        status: AuthConnectionStatus.done,
        event: () => event,
      ));
    }
  }

  /// REST sign up
  /*Future<void> restSignUp(Emitter<AuthState> emit, [FirebaseAuthSignInEvent? event]) async {
    User? firebaseUser = _firebaseInstance.currentUser;

    if (firebaseUser == null) {
      emit(
        AuthState(
          error: AuthErrorType.noUserSignedIn,
          status: AuthConnectionStatus.done,
          event: event,
          currentRoute: state.currentRoute,
        ),
      );
      return;
    }

    // Don't do the REST sign up until the email has been verified
    final isAuthByEmail = firebaseUser.providerData.firstOrNull?.providerId == 'password';
    if (isAuthByEmail && firebaseUser.emailVerified == false) {
      emit(
        AuthState(
          firebaseUser: firebaseUser,
          challenge: const AuthChallenge(
            type: AuthChallengeType.emailVerification,
          ),
          currentRoute: state.currentRoute,
        ),
      );

      return;
    }

    AuthError? error;

    FluxUser? fluxUser = state.fluxUser ?? AuthService().createFluxUserFromFirebase(firebaseUser);
    try {
      if (event is FirebaseEmailAuthEvent) {
        fluxUser = fluxUser.copyWith(password: event.password);
      }
      debugPrint('[AuthBloc] Signing up with user: $fluxUser');
      var token = await getUserToken();
      debugPrint(token);
      final result = await AuthService().signIn();
      debugPrint('[AuthBloc] Response from server: $result');
    } catch (e) {
      debugPrint(e.toString());

      error = AuthError.from(e);

      if (error.type == AuthErrorType.userNotFound) {
        // /// if the user is not found (should not happen), it means that the user was removed from the server
        // /// so we need to force firebase user to have a new uid

        // await firebaseUser.delete();

        // /// re-sign in the user with the current user's credentials if any
        // if (_userCredential?.credential != null) {
        //   await _firebaseInstance
        //       .signInWithCredential(_userCredential!.credential!);
        //   return;
        // } else {
        firebaseUser = null;
        fluxUser = null;
        await _firebaseInstance.signOut();
        // }
      } else {
        firebaseUser = null;
        fluxUser = null;
        await _firebaseInstance.signOut();
      }
    }
    emit(
      AuthState(
        error: error,
        fluxUser: fluxUser,
        firebaseUser: firebaseUser,
        currentRoute: state.currentRoute,
      ),
    );
  }*/

  Future<void> restSignInOrUp(Emitter<AuthState> emit, [FirebaseAuthSignInEvent? event]) async {
    User? firebaseUser = _firebaseInstance.currentUser;

    debugPrint('AuthBloc: restSignInOrUp: ${firebaseUser.toString()}');
    if (firebaseUser == null) {
      emit(
        AuthState(
          error: AuthErrorType.noUserSignedIn,
          status: AuthConnectionStatus.done,
          event: event,
          currentRoute: state.currentRoute,
        ),
      );
      return;
    }

    // Don't do the REST sign up until the email has been verified
    final isAuthByEmail = firebaseUser.providerData.firstOrNull?.providerId == 'password';
    if (isAuthByEmail && firebaseUser.emailVerified == false) {
      emit(
        AuthState(
          firebaseUser: firebaseUser,
          challenge: const AuthChallenge(
            type: AuthChallengeType.emailVerification,
          ),
          currentRoute: state.currentRoute,
        ),
      );

      return;
    }

    AuthError? error;
    FluxLogin? fluxLogin;

    FluxUser? fluxUser = state.fluxUser ?? AuthService().createFluxUserFromFirebase(firebaseUser);
    try {
      if (event is FirebaseEmailAuthEvent) {
        fluxUser = fluxUser.copyWith(password: event.password);
      }
      debugPrint('AuthBloc: restSignIn: Signing in with user: $fluxUser');
      var token = await getUserTokenFromFirebaseUser(firebaseUser: firebaseUser);
      debugPrint(token);
      if (token != null) {
        var loginPhrase = await AuthService().getLoginPhrase();
        final result = await AuthService().signIn(
          token: token,
          message: loginPhrase.loginPhrase,
        );
        debugPrint('AuthBloc: restSignIn: Response from server: $result');
        if (result.success) {
          fluxLogin = await AuthService().verifyLogin(
            zelid: result.publicAddress!,
            loginPhrase: loginPhrase.loginPhrase,
            signature: result.signature!,
          );
          add(UpdateFluxLoginEvent(fluxLogin));
        } else {}
      } else {}
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());

      error = AuthError.from(e);

      if (error.type == AuthErrorType.userNotFound) {
        // /// if the user is not found (should not happen), it means that the user was removed from the server
        // /// so we need to force firebase user to have a new uid

        // await firebaseUser.delete();

        // /// re-sign in the user with the current user's credentials if any
        // if (_userCredential?.credential != null) {
        //   await _firebaseInstance
        //       .signInWithCredential(_userCredential!.credential!);
        //   return;
        // } else {
        firebaseUser = null;
        fluxUser = null;
        await _firebaseInstance.signOut();
        // }
      } else {
        firebaseUser = null;
        fluxUser = null;
        await _firebaseInstance.signOut();
      }
    }
    emit(
      AuthState(
        error: error,
        fluxUser: fluxUser,
        firebaseUser: firebaseUser,
        fluxLogin: fluxLogin,
        currentRoute: state.currentRoute,
      ),
    );
  }
}
