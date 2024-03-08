import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as frb;
import 'package:flutter_base/api/api.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/data/flux_user.dart';

class AuthService {
  AuthService._p();

  static final AuthService _instance = AuthService._p();
  factory AuthService() => _instance;

  static AuthBloc? bloc;

  Future<bool> signUp() async {
    if (bloc == null) {
      throw ApiException(message: 'No AuthBloc');
    }
    Api? api = Api.instance;
    if (api == null) {
      throw ApiException(message: 'No API');
    }
    dynamic response = api.apiCall(
      RequestType.get,
      '/api/signUp',
      backendOverride: 'https://pouwdev.runonflux.io',
      options: Options(headers: {'Authorization': bloc!.getUserToken()}),
    );
    if (response is Map && response.containsKey('status')) {
      return response['status'] == 'Success';
    }
    throw ApiException(message: 'Invalid Data');
  }

  Future<SignInResult> signIn({required String message}) async {
    return SignInResult(success: false);
  }

  Future<SignMessageResult> signMessage({required String message}) async {
    return SignMessageResult();
  }

  FluxUser createFluxUserFromFirebase(frb.User firebaseUser) {
    String? firebaseEmail;
    if (firebaseUser.email != null && firebaseUser.providerData.any((e) => e.email == firebaseUser.email)) {
      firebaseEmail = firebaseUser.email;
    }
    return FluxUser(
        email: firebaseEmail,
        mobile: firebaseUser.phoneNumber,
        photo: firebaseUser.photoURL,
        uid: firebaseUser.uid,
        otp: false,
        active: true);
  }
}

class SignInResult {
  String? signature;
  String? publicAddress;
  bool success;
  String? error;

  SignInResult({
    required this.success,
    this.signature,
    this.publicAddress,
    this.error,
  });
}

class SignMessageResult {}
