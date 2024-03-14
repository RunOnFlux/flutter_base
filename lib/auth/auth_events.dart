part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class InitializeAuthEvent extends AuthEvent {
  const InitializeAuthEvent();
}

/// event to notify that the backup codes have been saved, and that
/// they should therefore be removed from the state, to change the UI
class BackupCodesSavedEvent extends AuthEvent {
  const BackupCodesSavedEvent();
}

class RefreshFirebaseUserEvent extends AuthEvent {
  const RefreshFirebaseUserEvent();
}

class AuthNotificationsEvent extends AuthEvent {
  const AuthNotificationsEvent(this.enable);

  factory AuthNotificationsEvent.enable() => const AuthNotificationsEvent(true);
  factory AuthNotificationsEvent.disable() => const AuthNotificationsEvent(false);

  final bool enable;
}

class TwoFactorEnableEvent extends AuthEvent {
  final bool enabled;
  const TwoFactorEnableEvent({required bool enable}) : enabled = enable;

  static const TwoFactorEnableEvent enable = TwoFactorEnableEvent(enable: true);
  static const TwoFactorEnableEvent disable = TwoFactorEnableEvent(enable: false);
  @override
  List<Object?> get props => [enabled];
}

/// internal events are used internally by the bloc, and should not be used
/// outside of it. It is mostly used to notify the firebase auth state changes
abstract class InternalAuthEvent extends AuthEvent {
  const InternalAuthEvent();
  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends AuthEvent {
  final String? displayName;
  final String? photoURL;

  const UpdateProfileEvent({required this.displayName, required this.photoURL});
}

class _InternalFirebaseSignOut extends InternalAuthEvent {
  const _InternalFirebaseSignOut();
}

class _InternalFirebaseSignIn extends InternalAuthEvent {
  const _InternalFirebaseSignIn(this.user);
  final User user;
  @override
  List<Object?> get props => [user];
}

/// event to notify that an error has occurred during the authentication,
/// directly from the grpc client interceptor
class _AuthErrorEvent extends InternalAuthEvent {
  const _AuthErrorEvent(this.error);
  final AuthError error;
  @override
  List<Object?> get props => [error];
}

/// Validate the email verification process by using the [oobCode] sent by
/// firebase
class CompleteEmailVerificationEvent extends AuthEvent {
  const CompleteEmailVerificationEvent(this.oobCode, {this.isChangeEmail = false});
  final String oobCode;
  final bool isChangeEmail;
  @override
  List<Object?> get props => [oobCode, isChangeEmail];
}

class CompletePasswordResetEvent extends AuthEvent {
  const CompletePasswordResetEvent(this.oobCode, this.password);
  final String oobCode;
  final String password;
  @override
  List<Object?> get props => [oobCode, password];
}

class RequestEmailVerificationEvent extends AuthEvent {
  const RequestEmailVerificationEvent({this.redirectUrl, this.silent = false});
  final String? redirectUrl;

  /// if [silent] is true, the event will not emit any state change
  final bool silent;
  @override
  List<Object?> get props => [silent, redirectUrl];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent(this.email);
  @override
  List<Object?> get props => [email];
}

class RequestDeleteAccountEvent extends AuthEvent {
  const RequestDeleteAccountEvent();
}

class _CancelActionEvent extends AuthEvent {
  /// used to log out user if the canceled challenge is not skippable
  final bool logUserOut;
  const _CancelActionEvent([this.logUserOut = false]);

  @override
  List<Object?> get props => super.props..add(logUserOut);
}

class RequestReauthenticateEvent extends AuthEvent {
  final AuthEvent? event;
  final Completer<bool>? _completer;
  final String? code;

  const RequestReauthenticateEvent({this.event, Completer<bool>? completer, this.code}) : _completer = completer;

  @override
  List<Object?> get props => [_completer, event, code];
}

/// use this event to validate a reauthenticate challenge
class ValidateReauthenticateEvent extends AuthEvent {
  const ValidateReauthenticateEvent(this.code) : force = false;

  const ValidateReauthenticateEvent._({required this.code, this.force = false});

  /// code to pass the reauthenticate challenge, if its a phone number, it should
  /// be the sms code, if its an email, it should be the password
  /// if its a provider, it is 'CONFIRM' translated
  final String code;
  final bool force;
  @override
  List<Object?> get props => [code, force];
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent([this.error]);
  final AuthErrorType? error;

  @override
  List<Object?> get props => [error];
}

/// Event to request a sign in with phone number
class SigninWithPhoneRequestEvent extends AuthEvent {
  final String phoneNumber;
  final Brightness recaptchaBrightness;

  const SigninWithPhoneRequestEvent(this.phoneNumber, [this.recaptchaBrightness = Brightness.light]);
  @override
  List<Object?> get props => [phoneNumber, recaptchaBrightness];
}

class TwoFactorValidateEvent extends AuthEvent {
  final String code;

  const TwoFactorValidateEvent(this.code);
  @override
  List<Object?> get props => [code];
}

class AuthRouteEvent extends AuthEvent {
  final AuthFluxRoute route;

  const AuthRouteEvent(this.route);
  @override
  List<Object?> get props => [route];
}

class UpdateFluxLoginEvent extends AuthEvent {
  final FluxLogin? login;

  const UpdateFluxLoginEvent(this.login);
  @override
  List<Object?> get props => [login];
}

///
///
///
/// Sign in with Firebase
abstract class FirebaseAuthSignInEvent extends AuthEvent {
  const FirebaseAuthSignInEvent();
  @override
  List<Object?> get props => [];

  static SigninWithPhoneRequestEvent signInByPhone(String phoneNumber, Brightness brightness) =>
      SigninWithPhoneRequestEvent(phoneNumber, brightness);

  static FirebaseEmailAuthEvent signInByEmail(String email, String password) =>
      FirebaseEmailAuthEvent._(false, email: email, password: password);
  static FirebaseEmailAuthEvent signUpByEmail(String email, String password) =>
      FirebaseEmailAuthEvent._(true, email: email, password: password);
}

class FirebaseEmailAuthEvent extends FirebaseAuthSignInEvent {
  final String email;
  final String password;
  final bool isSignUp;

  const FirebaseEmailAuthEvent._(this.isSignUp, {required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event to finalize the sign in with phone number process,
/// using the sms code sent to the user and the [PhoneSigninRequest] object
class FirebasePhoneAuthEvent extends FirebaseAuthSignInEvent {
  final String smsCode;
  final PhoneSigninRequest request;

  static SigninWithPhoneRequestEvent resendCode(PhoneSigninRequest otpRequest) => otpRequest.event;

  const FirebasePhoneAuthEvent(this.smsCode, this.request);

  @override
  List<Object?> get props => [smsCode, request];
}

class FirebaseProviderAuthEvent extends FirebaseAuthSignInEvent {
  final FirebaseSignInMethods provider;

  const FirebaseProviderAuthEvent._(this.provider);

  factory FirebaseProviderAuthEvent.fromFirebaseSignInMethods(FirebaseSignInMethods method) {
    return FirebaseProviderAuthEvent._(method);
  }

  factory FirebaseProviderAuthEvent.google() => const FirebaseProviderAuthEvent._(FirebaseSignInMethods.google);

  // factory FirebaseProviderAuthEvent.facebook() =>
  //     const FirebaseProviderAuthEvent._(FirebaseSignInMethods.facebook);

  factory FirebaseProviderAuthEvent.gitlab() => const FirebaseProviderAuthEvent._(FirebaseSignInMethods.gitlab);

  factory FirebaseProviderAuthEvent.github() => const FirebaseProviderAuthEvent._(FirebaseSignInMethods.github);

  @override
  List<Object?> get props => [provider];
}

class VerifyPhoneEvent extends AuthEvent {
  const VerifyPhoneEvent._({this.phoneNumber, Completer<PhoneAuthCredential?>? completer}) : _completer = completer;
  final String? phoneNumber;
  final Completer<PhoneAuthCredential?>? _completer;

  const VerifyPhoneEvent(String phoneNumber) : this._(phoneNumber: phoneNumber);

  @override
  List<Object?> get props => [_completer, phoneNumber];
}

class LinkAuthProviderEvent extends AuthEvent {
  final FirebaseSignInMethods method;

  LinkAuthProviderEvent({required this.method})
      : assert(FirebaseSignInMethods.supportedProviders.contains(method), 'Linking $method is not supported');

  @override
  List<Object?> get props => [method];
}

class UnlinkAuthProviderEvent extends AuthEvent {
  final FirebaseSignInMethods method;

  UnlinkAuthProviderEvent({required this.method})
      : assert(FirebaseSignInMethods.supportedProviders.contains(method), 'Unlinking $method is not supported');

  @override
  List<Object?> get props => [method];
}

class UpdateEmailEvent extends AuthEvent {
  final String newEmail;
  final String? currentEmail;
  final String password;

  final bool link;

  const UpdateEmailEvent._({required this.newEmail, this.currentEmail, required this.password, this.link = false});

  factory UpdateEmailEvent.change({required String email, required String password, required String newEmail}) =>
      UpdateEmailEvent._(newEmail: newEmail, password: password, currentEmail: email);

  factory UpdateEmailEvent.link({required String email, required String password}) =>
      UpdateEmailEvent._(newEmail: email, password: password, link: true);

  @override
  List<Object?> get props => [newEmail, password, currentEmail];
}

class UpdatePasswordEvent extends AuthEvent {
  final String password;
  final String oldPassword;

  const UpdatePasswordEvent(this.oldPassword, this.password);

  @override
  List<Object?> get props => [password, oldPassword];
}

class UpdatePhoneNumberEvent extends AuthEvent {
  final String phoneNumber;

  const UpdatePhoneNumberEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

enum AuthErrorType {
  // don't change order, as their index is used as a reference code, a new type of error should be added at the end
  invalidDisposableEmail,
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  tooManyRequests,
  operationNotAllowed,
  expiredActionCode,
  invalidActionCode,
  weakPassword,
  invalidCredential,
  accountExistsWithDifferentCredential,
  networkRequestFailed,
  invalidPhoneNumber,
  captchaCheckFailed,
  emailAlreadyInUse,
  quotaExceeded,
  popupClosedByUser,
  credentialAlreadyInUse,
  emailVerificationCooldown,
  alreadySignedInWithPhone,

  timeout,
  serverError,
  disablingTwoFactorAuthenticationFailed,
  twoFactorOTPFail,
  needTwoFactorAuthentication,
  noUserSignedIn,
  emailAlreadyVerified,
  wrongEmail,
  alreadySignedIn,
  unknown,
  firebaseNotInitialized,
  accountHasNoEmail,
  phoneAuthDisabled,
  accountHasEmail;

  static AuthErrorType fromFirebaseAuthException(FirebaseAuthException exception,
      [AuthErrorType orElse = AuthErrorType.unknown]) {
    switch (exception.code) {
      case 'credential-already-in-use':
        return AuthErrorType.credentialAlreadyInUse;
      case 'popup-closed-by-user':
        return AuthErrorType.popupClosedByUser;
      case 'quota-exceeded':
        return AuthErrorType.quotaExceeded;
      case 'invalid-verification-code':
        return AuthErrorType.twoFactorOTPFail;
      case 'invalid-phone-number':
        return AuthErrorType.invalidPhoneNumber;
      case 'network-request-failed':
        return AuthErrorType.networkRequestFailed;
      case 'missing-email':
        return AuthErrorType.invalidEmail;
      case 'invalid-email':
        return AuthErrorType.invalidEmail;
      case 'user-disabled':
        return AuthErrorType.userDisabled;
      case 'user-not-found':
        return AuthErrorType.userNotFound;
      case 'wrong-password':
        return AuthErrorType.wrongPassword;
      case 'too-many-requests':
        return AuthErrorType.tooManyRequests;
      case 'operation-not-allowed':
        return AuthErrorType.operationNotAllowed;
      case 'expired-action-code':
        return AuthErrorType.expiredActionCode;
      case 'invalid-action-code':
        return AuthErrorType.invalidActionCode;
      case 'weak-password':
        return AuthErrorType.weakPassword;
      case 'email-already-in-use':
        return AuthErrorType.emailAlreadyInUse;
      case 'invalid-credential':
        return AuthErrorType.invalidCredential;
      case 'account-exists-with-different-credential':
        return AuthErrorType.accountExistsWithDifferentCredential;
      case 'captcha-check-failed':
        return AuthErrorType.captchaCheckFailed;
      case 'user-token-expired':
        return AuthErrorType.noUserSignedIn;
      default:
        debugPrint('\x1B[31m${exception.code} (UNEXPECTED) name: \x1B[31mAuthError.fromFirebaseAuthException');
        return orElse;
    }
  }

  static AuthErrorType from(Object error) {
    if (error is AuthErrorType) {
      return error;
    }
    if (error is FirebaseAuthException) {
      return fromFirebaseAuthException(error);
    }
    try {
      String? code;
      final errorStr = error.toString();
      if (errorStr.startsWith('FirebaseError:')) {
        code = RegExp(r'\((.*?)\)').firstMatch(errorStr)?.group(1);
      } else {
        code = (error as dynamic)?.code.as<String>();
      }
      if (code != null) {
        final firebaseAuthCode = code.replaceFirst('auth/', '');
        if (firebaseAuthCode != code) {
          return fromFirebaseAuthException(FirebaseAuthException(code: firebaseAuthCode));
        }
      }
    } catch (e) {
      //
    }
    if (error is TimeoutException) {
      return AuthErrorType.timeout;
    }
    return AuthErrorType.unknown;
  }
}
