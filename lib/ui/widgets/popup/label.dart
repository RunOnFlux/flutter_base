import 'package:flutter/material.dart';

enum PopupMessageLabel {
  error,
  warning,
  success,
  update;

  @override
  String toString() {
    switch (this) {
      case PopupMessageLabel.error:
        return 'Error';
      case PopupMessageLabel.warning:
        return 'Warning';
      case PopupMessageLabel.success:
        return 'Success';
      case PopupMessageLabel.update:
        return 'Update';
    }
  }

  Color get borderColor {
    switch (this) {
      case PopupMessageLabel.error:
        return const Color(0xFFFDA29B);
      case PopupMessageLabel.warning:
        return const Color(0xFFFEDF89);
      case PopupMessageLabel.success:
        return const Color(0xFF75E0A7);
      case PopupMessageLabel.update:
        return const Color(0xFF2B61D1);
    }
  }

  Color get backgroundColorOfLabel {
    switch (this) {
      case PopupMessageLabel.error:
        return const Color(0xFFFEF3F2);
      case PopupMessageLabel.warning:
        return const Color(0xFFFFFAEB);
      case PopupMessageLabel.success:
        return const Color.fromARGB(255, 240, 255, 246);
      case PopupMessageLabel.update:
        return const Color.fromARGB(255, 235, 242, 255);
    }
  }

  Color get textColor {
    switch (this) {
      case PopupMessageLabel.error:
        return const Color(0xFFB42318);
      case PopupMessageLabel.warning:
        return const Color(0xFFB54708);
      case PopupMessageLabel.success:
        return const Color(0xFF067647);
      case PopupMessageLabel.update:
        return const Color(0xFF2B61D1);
    }
  }

  Color get foregroundColor {
    switch (this) {
      case PopupMessageLabel.error:
        return const Color(0xFFB42318);
      case PopupMessageLabel.warning:
        return const Color(0xFFB54708);
      case PopupMessageLabel.success:
        return const Color(0xFF067647);
      case PopupMessageLabel.update:
        return const Color(0xFF2B61D1);
    }
  }

  Color get closeButtonColor {
    switch (this) {
      case PopupMessageLabel.error:
        return const Color(0xFFF04438);
      case PopupMessageLabel.warning:
        return const Color(0xFFF79009);
      case PopupMessageLabel.success:
        return const Color(0xFF17B26A);
      case PopupMessageLabel.update:
        return const Color(0xFF2B61D1);
    }
  }
}
