part of 'auth_bloc.dart';

enum FirebaseSignInMethods {
  email,
  google,
  github,
  apple,
  gitlab(canBeLinked: false),
  phone(canBeLinked: false);

  bool isProvider() {
    return supportedProviders.contains(this);
  }

  bool get active {
    if (this == phone || this == gitlab) {
      //return !FluxAuthSystem.config.disablePhoneAuth;
      return false;
    }

    return true;
  }

  static List<FirebaseSignInMethods> get linkableMethods {
    return FirebaseSignInMethods.values.where((e) => e.canBeLinked).toList();
  }

  static List<FirebaseSignInMethods> get activeMethods {
    return FirebaseSignInMethods.values.where((e) => e.active).toList();
  }

  /// whether the provider can be linked to an existing account
  final bool canBeLinked;

  const FirebaseSignInMethods({this.canBeLinked = true});

  static const List<FirebaseSignInMethods> supportedProviders = [
    FirebaseSignInMethods.google,
    FirebaseSignInMethods.github,
    FirebaseSignInMethods.apple,
    //FirebaseSignInMethods.gitlab
  ];

  static const List<FirebaseSignInMethods> otherMethods = [FirebaseSignInMethods.email, FirebaseSignInMethods.phone];

  static FirebaseSignInMethods? fromProviderId(String id) {
    try {
      final r = FirebaseSignInMethods.values.firstWhere((e) => e.providerId == id);
      if (r.active == true) {
        return r;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String get providerId {
    switch (this) {
      case FirebaseSignInMethods.google:
        return 'google.com';
      // case FirebaseSignInMethods.facebook:
      //   return 'facebook.com';
      case FirebaseSignInMethods.email:
        return 'password';
      case FirebaseSignInMethods.phone:
        return 'phone';
      case FirebaseSignInMethods.apple:
        return 'apple';
      case FirebaseSignInMethods.github:
        return 'github.com';
      case FirebaseSignInMethods.gitlab:
        return 'gitlab.com';
    }
  }

  String get providerName {
    switch (this) {
      case FirebaseSignInMethods.google:
        return 'Google';
      // case FirebaseSignInMethods.facebook:
      //   return 'Facebook';
      case FirebaseSignInMethods.email:
        return 'E-mail address';
      case FirebaseSignInMethods.phone:
        return 'Phone number';
      case FirebaseSignInMethods.apple:
        return 'Apple ID';
      case FirebaseSignInMethods.github:
        return 'Github';
      case FirebaseSignInMethods.gitlab:
        return 'Gitlab';
    }
  }

  Widget get icon {
    String assetName;

    switch (this) {
      case FirebaseSignInMethods.github:
        return Builder(builder: (context) {
          final colorFilter = Theme.of(context).brightness == Brightness.dark
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null;
          return SvgPicture.asset(
            'assets/images/svg/github.svg',
            package: 'flutter_base',
            colorFilter: colorFilter,
          );
        });
      case FirebaseSignInMethods.google:
        assetName = 'assets/images/svg/google.svg';
      // case FirebaseSignInMethods.facebook:
      //   assetName = 'assets/images/svg/facebook.svg';
      case FirebaseSignInMethods.email:
        assetName = 'assets/images/svg/email.svg';
      case FirebaseSignInMethods.phone:
        assetName = 'assets/images/svg/phone.svg';
      case FirebaseSignInMethods.apple:
        assetName = 'assets/images/svg/apple.svg';
      case FirebaseSignInMethods.gitlab:
        assetName = 'assets/images/svg/gitlab.svg';
    }
    return SvgPicture.asset(assetName, package: 'flutter_base');
  }

  AuthProvider? get authProvider {
    switch (this) {
      case FirebaseSignInMethods.google:
        return GoogleAuthProvider();

      case FirebaseSignInMethods.email:
        return null;
      case FirebaseSignInMethods.phone:
        return PhoneAuthProvider();
      case FirebaseSignInMethods.apple:
        return AppleAuthProvider();
      case FirebaseSignInMethods.github:
        return GithubAuthProvider();
      case FirebaseSignInMethods.gitlab:
        return GitlabAuthProvider();
    }
  }
}

/// the time in seconds before the user can request a new sms code
const kTimeToResendSMSCode = 60;

enum AuthChallengeType<T extends Object?> {
  emailVerification(skippable: false),
  configureTwoFactorAuthentication<TwoFactorConfigRequest>(),
  saveTwoFactorAuthenticationBackupCodes<Validate2FAOTPResult>(),
  twoFactorAuthentication(skippable: false),
  reauthentication(skippable: false);

  AuthFluxChallengeRoute get route {
    switch (this) {
      case AuthChallengeType.twoFactorAuthentication:
        return AuthFluxChallengeRoute.needTwoFactorAuth;
      case AuthChallengeType.reauthentication:
        return AuthFluxChallengeRoute.needReauthentication;
      case AuthChallengeType.emailVerification:
        return AuthFluxChallengeRoute.needAccountEmailVerification;
      case AuthChallengeType.configureTwoFactorAuthentication:
        return AuthFluxChallengeRoute.confTwoFactorAuth;
      case AuthChallengeType.saveTwoFactorAuthenticationBackupCodes:
        return AuthFluxChallengeRoute.saveTwoFactorAuthCodes;
    }
  }

  final bool skippable;

  const AuthChallengeType({this.skippable = true});
}

class AuthChallenge<T extends Object?> {
  final AuthChallengeType<T?> type;
  final T? extra;

  const AuthChallenge({required this.type, this.extra});

  @override
  String toString() => 'AuthChallenge(type: $type, extra: $extra)';

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is AuthChallenge) {
      return other.type == type && other.extra == extra;
    }
    return false;
  }

  @override
  int get hashCode => type.hashCode ^ extra.hashCode;
}

enum AuthResult {
  signInOrUpCompleted(silent: true),
  emailSent,
  emailSentToChangeEmail,
  emailVerified,
  emailVerifiedAndUpdated,
  emailUpdated,
  accountDeleted,
  passwordResetCompleted,
  passwordUpdated,
  phoneUpdated,
  profileUpdated,
  twoFactorAuthenticationCompleted,
  reauthenticationCompleted(silent: true),
  linkedProvider,
  unlinkedProvider;

  final bool silent;

  const AuthResult({this.silent = false});

  /*@override
  String trMatcher(FluxAuthLocalizations s, Object? arg) {
    switch (this) {
      case AuthResult.profileUpdated:
        return s.authProfileUpdated;
      case AuthResult.passwordUpdated:
        return s.authPasswordUpdated;
      case AuthResult.signInOrUpCompleted:
        return s.signInSuccessMessage('');
      case AuthResult.emailSentToChangeEmail:
        return s.authEmailSentToChangeEmail;
      case AuthResult.emailUpdated:
        return s.authEmailUpdated;
      case AuthResult.emailVerifiedAndUpdated:
        return s.authEmailVerifiedAndUpdated;
      case AuthResult.phoneUpdated:
        return s.authPhoneUpdated;
      case AuthResult.emailSent:
        return s.authEmailSent;
      case AuthResult.accountDeleted:
        return s.authAccountDeleted;
      case AuthResult.emailVerified:
        return s.authEmailVerified;
      case AuthResult.passwordResetCompleted:
        return s.authResetPasswordSuccess;
      case AuthResult.twoFactorAuthenticationCompleted:
        return s.authTwoFactorAuthenticationCompleted;
      case AuthResult.reauthenticationCompleted:
        return s.authReauthenticationCompleted;
      case AuthResult.linkedProvider:
        return s.authLinkedProvider;
      case AuthResult.unlinkedProvider:
        return s.authUnlinkedProvider;
    }
  }*/

  //@override
  //bool get keepAlive => false;
}

class PhoneSigninRequest extends Equatable {
  final ConfirmationResult result;
  final DateTime timestamp;
  final SigninWithPhoneRequestEvent event;

  const PhoneSigninRequest(this.result, this.timestamp, this.event);

  bool expired() {
    return DateTime.now().difference(timestamp).inSeconds > kTimeToResendSMSCode;
  }

  int remainingTime() {
    return kTimeToResendSMSCode - DateTime.now().difference(timestamp).inSeconds;
  }

  @override
  List<Object?> get props => [result, timestamp, event];
}

class PhoneVerificationRequest {
  final String verificationId;
  final String phoneNumber;
  PhoneVerificationRequest({required this.verificationId, required this.phoneNumber}) : _completer = Completer() {
    assert(verificationId.isNotEmpty);
    assert(phoneNumber.isNotEmpty);
  }

  void complete(String code) {
    if (_completer.isCompleted) {
      return;
    }
    _onValidationRequested?.call(code);
    _completer.complete(code);
  }

  void Function(String code)? _onValidationRequested;
  void Function()? _onResendRequested;

  void onValidationRequested(void Function(String code) callback) {
    _onValidationRequested = callback;
  }

  void onResendRequested(void Function() callback) {
    _onResendRequested = callback;
  }

  void resend() {
    if (_completer.isCompleted) {
      return;
    }
    _onResendRequested?.call();
    _completer.completeError('resend-code');
  }

  Future<String> get code => _completer.future;

  final Completer<String> _completer;
}

class AuthError {
  final AuthErrorType type;
  final Object? error;

  static AuthError fromFirebaseAuthException(FirebaseAuthException e) {
    return AuthError(type: AuthErrorType.fromFirebaseAuthException(e));
  }

  static AuthError ofType(AuthErrorType type) {
    return AuthError(type: type);
  }

  static AuthError from(Object error) {
    if (error is AuthError) {
      return error;
    }
    if (error is AuthErrorType) {
      return AuthError(type: error);
    }
    return AuthError(type: AuthErrorType.from(error), error: error);
  }

  const AuthError({required this.type, this.error});

  @override
  String toString() {
    return 'AuthError(type: $type, error: $error)';
  }
}

class TwoFactorConfigRequest {
  final Uri _uri;

  /// whether the request is made by the user or by the app
  final bool isUserRequest;

  TwoFactorConfigRequest({required Uri uri, this.isUserRequest = false}) : _uri = uri;

  factory TwoFactorConfigRequest.from(String uri, {bool isUserRequest = false}) {
    return TwoFactorConfigRequest(uri: Uri.parse(uri), isUserRequest: isUserRequest);
  }

  String get qrCode => _uri.toString();

  @override
  String toString() => 'TwoFactorConfigRequest(uri: $_uri)';

  String? get secretCode => _uri.queryParameters['secret'];
}

class Validate2FAOTPResult {
  final Iterable<String>? recovery2FACodes;

  const Validate2FAOTPResult(this.recovery2FACodes);
}

enum PrivilegeLevel {
  none('none'),
  user('user'),
  admin('admin'),
  fluxteam('fluxteam');

  const PrivilegeLevel(this.level);
  final String level;

  static PrivilegeLevel? fromString(String level) {
    List<PrivilegeLevel> levels = PrivilegeLevel.values;
    for (var element in levels) {
      if (element.level == level) return element;
    }
    return null;
  }
}
