import 'package:flutter/material.dart';

class Shadows {
  static cardHeaderShadow(BuildContext context) {
    return Shadow(
      blurRadius: 3.0,
      color: Theme.of(context).textTheme.titleLarge!.decorationColor!,
      offset: const Offset(1, 1),
    );
  }
}
