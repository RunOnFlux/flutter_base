import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as frb;
import 'package:flutter/foundation.dart';
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
    var token = await bloc!.getUserToken();
    dynamic response = await api.apiCall(
      RequestType.get,
      '/api/signUp',
      backendOverride: 'https://pouwdev.runonflux.io',
      options: Options(headers: {'Authorization': token}),
    );
    debugPrint(response.toString());
    if (response is Map && response.containsKey('status')) {
      return response['status'].toString().toLowerCase() == 'success';
    }
    throw ApiException(message: 'Invalid Data');
  }

  Future<SignInResult> signIn({required String message}) async {
    if (bloc == null) {
      throw ApiException(message: 'No AuthBloc');
    }
    Api? api = Api.instance;
    if (api == null) {
      throw ApiException(message: 'No API');
    }
    var token = await bloc!.getUserToken();
    debugPrint(token);
    dynamic response = await api.apiCall(
      RequestType.post,
      '/api/signIn',
      backendOverride: 'https://pouwdev.runonflux.io',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      body: {
        'message': message,
      },
    );
    debugPrint(response.toString());
    if (response is Map && response.containsKey('status')) {
      var success = response['status'].toString().toLowerCase() == 'success';
      return SignInResult(
        success: success,
        error: response['error'],
        signature: response['signature'],
        publicAddress: response['public_address'],
      );
    }
    throw ApiException(message: 'Invalid Data');
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
