import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/auth/connection_status.dart';
import 'package:flutter_base/data/flux_user.dart';
import 'package:flutter_base/extensions/try_cast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

export 'package:firebase_auth/firebase_auth.dart'
    hide User
    show EmailAuthProvider, PhoneAuthProvider, FirebaseAuth, PhoneAuthCredential, AuthCredential;

part 'auth_data.dart';
part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState());

  Future<void> init([Duration? timeout = const Duration(seconds: 10)]) async {
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
}
