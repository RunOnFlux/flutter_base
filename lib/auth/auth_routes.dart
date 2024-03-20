import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:go_router/go_router.dart';

mixin AuthFluxRoute<T extends Object?> {
  T getArg(AuthState authState, GoRouterState routerState);

  String get mode;
}

enum AuthFluxChallengeRoute<T> with AuthFluxRoute<T> {
  needAccountEmailVerification(),
  needReauthentication(),
  needTwoFactorAuth(),
  confTwoFactorAuth<TwoFactorConfigRequest>(),
  saveTwoFactorAuthCodes<Validate2FAOTPResult>();

  @override
  T getArg(AuthState authState, GoRouterState routerState) {
    switch (this) {
      case AuthFluxChallengeRoute.confTwoFactorAuth:
        return authState.twoFactorConfigRequest as T;
      case AuthFluxChallengeRoute.saveTwoFactorAuthCodes:
        return authState.twoFactorOTPResult as T;
      case AuthFluxChallengeRoute.needReauthentication:
      case AuthFluxChallengeRoute.needTwoFactorAuth:
      case AuthFluxChallengeRoute.needAccountEmailVerification:
      default:
        return null as T;
    }
  }

  @override
  String get mode => name;
}

/// All the routes of the Auth section
enum AuthFluxBranchRoute<T> with AuthFluxRoute<T> {
  verifyEmail<String?>(),
  login(isSignIn: true),
  register(isSignIn: true),
  phoneVerification<PhoneSigninRequest>(isSignIn: true),
  forgotPassword(),
  resetPassword<String?>(),
  verifyAndChangeEmail<String?>();

  static const List<AuthFluxBranchRoute> signInRoutes = [
    AuthFluxBranchRoute.login,
    AuthFluxBranchRoute.register,
    AuthFluxBranchRoute.phoneVerification,
    AuthFluxBranchRoute.forgotPassword
  ];

  static const List<AuthFluxBranchRoute> actionRoutes = [
    AuthFluxBranchRoute.resetPassword,
    AuthFluxBranchRoute.verifyEmail,
    AuthFluxBranchRoute.verifyAndChangeEmail
  ];

  @override
  String get mode => name;

  final bool isSignIn;
  const AuthFluxBranchRoute({this.isSignIn = false});

  static const String rootPath = '/auth';

  //@override
  String get fullPath => '$rootPath/$mode';

  static AuthFluxBranchRoute? fromName(String modeName) {
    try {
      final r = AuthFluxBranchRoute.values.firstWhere((e) => e.mode == modeName);
      return r;
    } catch (e) {
      return null;
    }
  }

  static AuthFluxBranchRoute? fromUri(Uri uri) {
    final modeName = uri.pathSegments[1];
    return fromName(modeName);
  }

  @override
  T getArg(AuthState authState, GoRouterState routerState) {
    final uri = routerState.uri;
    switch (this) {
      case AuthFluxBranchRoute.resetPassword:
      case AuthFluxBranchRoute.verifyEmail:
      case AuthFluxBranchRoute.verifyAndChangeEmail:
        return uri.queryParameters['oobCode'] as T;
      case AuthFluxBranchRoute.phoneVerification:
        return authState.phoneSignInOTPRequest as T;
      default:
        return null as T;
    }
  }

  bool canContinueNavigation(AuthState authState, String? oobCode) {
    if (this == AuthFluxBranchRoute.verifyEmail) {
      if (oobCode == null || oobCode.isEmpty || authState.isAuthenticatedAndVerified) {
        return false;
      }

      return true;
    }
    if (authState.hasChallenge) {
      return false;
    }
    switch (this) {
      case AuthFluxBranchRoute.login:
      case AuthFluxBranchRoute.forgotPassword:
        return authState.isNotAuthenticated;
      case AuthFluxBranchRoute.register:
        //if (!FluxAuthSystem.config.enableSignUp) {
        //  return false;
        //}
        return authState.isNotAuthenticated;
      case AuthFluxBranchRoute.phoneVerification:
        return authState.signInByPhoneProcessStarted && authState.isNotAuthenticated;
      case AuthFluxBranchRoute.resetPassword:
        return authState.isNotAuthenticated && oobCode != null;
      case AuthFluxBranchRoute.verifyAndChangeEmail:
        return oobCode != null;
      default:
        return true;
    }
  }
}
