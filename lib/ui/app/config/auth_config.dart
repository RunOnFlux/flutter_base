import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/ui/widgets/auth/screens/forgot_password.dart';
import 'package:flutter_base/ui/widgets/auth/screens/sign_in.dart';
import 'package:flutter_base/ui/widgets/auth/screens/verify_email.dart';

abstract class AuthConfig {
  Widget Function(Object? arg) authPageBuilder(AuthFluxRoute route) {
    switch (route) {
      case AuthFluxBranchRoute.login:
        return (_) => const SignInScreen();
      case AuthFluxBranchRoute.register:
        return (_) => const SignInScreen(type: SignInScreenType.register);
      case AuthFluxBranchRoute.forgotPassword:
        return (_) => const ForgotPasswordScreen();
      case AuthFluxBranchRoute.resetPassword:
        //return (arg) => resetPasswordPage(arg as String);
        return (_) => Container();
      case AuthFluxBranchRoute.verifyEmail:
        //return (arg) => verifyEmailPage(arg as String);
        return (_) => Container();
      case AuthFluxChallengeRoute.needAccountEmailVerification:
        //return (_) => needEmailVerificationPage();
        return (_) => const NeedEmailVerificationScreen();
      case AuthFluxBranchRoute.verifyAndChangeEmail:
        //return (arg) => verifyAndChangeEmailPage(arg as String);
        return (_) => Container();
      case AuthFluxChallengeRoute.needReauthentication:
        //return (_) => needReauthenticationPage();
        return (_) => Container();
      case AuthFluxChallengeRoute.needTwoFactorAuth:
        //return (_) => needTwoFactorAuthenticationPage();
        return (_) => Container();
      case AuthFluxChallengeRoute.confTwoFactorAuth:
        //return (arg) => confTwoFactorAuthenticationPage(arg as TwoFactorConfigRequest);
        return (_) => Container();
      case AuthFluxChallengeRoute.saveTwoFactorAuthCodes:
        //return (arg) => backupCodesPage(arg as Validate2FAOTPResult);
        return (_) => Container();
      case AuthFluxBranchRoute.phoneVerification:
        //return (arg) => phoneVerificationPage(arg as PhoneSigninRequest);
        return (_) => Container();
      default:
        throw Exception('Unknown route: $route');
    }
  }

  Image getImage(BuildContext context);
  Widget rightChild(BuildContext context);

  bool get allowSignUp => true;

  FirebaseOptions? get firebaseOptions => null;
}
