import 'package:flutter/cupertino.dart';

import 'default_colors.dart';

/// to handle failure, success, help and warning `ContentType` class is being used
class SnackbarType {
  /// message is `required` parameter
  final String message;

  /// color is optional, if provided null then `DefaultColors` will be used
  final Color? color;

  SnackbarType(this.message, [this.color]);

  static SnackbarType help = SnackbarType('help', DefaultColors.helpBlue);
  static SnackbarType failure = SnackbarType('failure', DefaultColors.failureRed);
  static SnackbarType success = SnackbarType('success', DefaultColors.successGreen);
  static SnackbarType warning = SnackbarType('warning', DefaultColors.warningYellow);

  static Map<String, SnackbarType> types = {
    'success': success,
    'help': help,
    'failure': failure,
    'warning': warning,
  };
}
