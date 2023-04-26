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
  }) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
            title: title ?? const Text('Are you sure?'),
            content: content,
            actions: <Widget>[
              ElevatedButton(
                onPressed: onOK == null
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        onOK();
                      },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(okColor ?? Colors.green)),
                child: okButton ?? const Text('OK'),
              ),
              if (cancelButton != null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(cancelColor ?? Colors.red)),
                  child: cancelButton,
                ),
            ],
          );
        },
      ),
    );
  }
}
