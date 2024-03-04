mixin PasswordValidator {
  /// Password validator (minimum 6 characters, 1 uppercase, 1 lowercase, 1 special character, 1 digit)
  bool validatePassword(String value) {
    return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$').hasMatch(value);
  }
}
