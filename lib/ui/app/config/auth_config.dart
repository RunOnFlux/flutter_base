import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base/auth/auth_routes.dart';

abstract class AuthConfig {
  Widget Function(Object? arg) authPageBuilder(AuthFluxRoute route);

  Image getImage(BuildContext context);
  Widget rightChild(BuildContext context);

  bool get allowSignUp => true;

  FirebaseOptions? get firebaseOptions => null;
}
