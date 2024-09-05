import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConfirmDialog {
  static void showConfirmDialog({
    required BuildContext context,
    Widget? title,
    required Widget content,
    Widget? okButton,
    void Function()? onOK,
    Widget? cancelButton,
    Color? okColor,
    Color? cancelColor,
    ValueListenable? buttonListener,
    Function()? Function(BuildContext)? okEnabled,
  }) {
    dynamic dialogValue;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          Widget dialog = AlertDialog(
            title: title ?? const Text('Are you sure?'),
            content: content,
            actions: <Widget>[
              ElevatedButton(
                onPressed: okEnabled != null
                    ? okEnabled(context)
                    : (onOK == null
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            onOK();
                          }),
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(okColor ?? Colors.green)),
                child: okButton ?? const Text('OK'),
              ),
              if (cancelButton != null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(cancelColor ?? Colors.red)),
                  child: cancelButton,
                ),
            ],
          );
          if (buttonListener != null) {
            dialog = ValueListenableBuilder(
              valueListenable: buttonListener,
              builder: (context, value, child) {
                if (value != dialogValue) {
                  Future.microtask(() {
                    setState(() {
                      dialogValue = value;
                    });
                  });
                }
                return dialog;
              },
            );
          }
          return dialog;
        },
      ),
    );
  }
}
