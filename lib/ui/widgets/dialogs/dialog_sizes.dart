import 'package:flutter/material.dart';

mixin DialogSizes {
  Padding padDialog(Widget body) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 50,
        bottom: 50,
      ),
      child: body,
    );
  }
}
