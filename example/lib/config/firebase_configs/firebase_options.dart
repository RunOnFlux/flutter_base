import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base_example/config/constants.dart';

import 'src/firebase_dev_options.dart' as dev;
import 'src/firebase_prod_options.dart' as prod;

class AuthFirebaseOptions {
  final FirebaseOptions web;
  final FirebaseOptions currentPlatform;

  const AuthFirebaseOptions({required this.web, required this.currentPlatform});

  factory AuthFirebaseOptions.fromEnvironment(Environment env) {
    return AuthFirebaseOptions(
        web: env == Environment.prod ? prod.DefaultFirebaseOptions.web : dev.DefaultFirebaseOptions.web,
        currentPlatform: env == Environment.prod
            ? prod.DefaultFirebaseOptions.currentPlatform
            : dev.DefaultFirebaseOptions.currentPlatform);
  }
}
