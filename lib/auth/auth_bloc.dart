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

class AuthBloc<U extends FluxUser> extends Bloc<AuthEvent, AuthState<U>> {
  AuthBloc(super.initialState);
}
