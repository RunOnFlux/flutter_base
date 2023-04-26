import 'package:flutter/material.dart';

import 'snack/snackbar_content.dart';
import 'snack/snackbar_type.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

snack(String title, String message, {SnackbarType? type}) {
  if (rootScaffoldMessengerKey.currentState != null) {
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 0.0),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: SnackbarContent(
          title: title,
          message: message,

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: type ?? SnackbarType.success,
        ),
      ),
    );
  }
}
