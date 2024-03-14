// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_base/auth/auth_bloc.dart';

import 'src/web.dart' if (dart.library.io) 'src/native.dart';

class GitlabAuthProvider extends AuthProvider {
  GitlabAuthProvider() : super(FirebaseSignInMethods.gitlab.providerId);

  Future<UserCredential> signIn() async {
    try {
      final token = await signInWithGitlab();
      final userCredential = await FirebaseAuth.instance.signInWithCustomToken(token);
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> dispose() {
    return close();
  }
}
