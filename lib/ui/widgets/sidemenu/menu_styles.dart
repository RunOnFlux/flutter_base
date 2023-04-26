import 'package:flutter/material.dart';

mixin MenuStyles {
  Widget buildImage(BuildContext context, Image? image, {bool selected = false}) {
    return image != null
        ? SizedBox(
            height: 22,
            width: 22,
            child: image,
          )
        : const SizedBox();
  }

  Widget buildIcon(BuildContext context, IconData? icon, {bool selected = false, double size = 22}) {
    return icon != null
        ? SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              size: size,
              color: selected
                  ? Theme.of(context).textTheme.titleLarge?.decorationColor
                  : Theme.of(context).textTheme.titleLarge?.color,
            ),
          )
        : const SizedBox();
  }

  Widget buildTitle(BuildContext context, String title, int level, {bool selected = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: _fontSizeForLevel(level),
        color: selected
            ? Theme.of(context).textTheme.titleLarge?.decorationColor
            : Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget buildSmallTitle(BuildContext context, String title, {bool selected = false}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10,
        color: selected
            ? Theme.of(context).textTheme.titleLarge?.decorationColor
            : Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  double _fontSizeForLevel(int level) {
    switch (level) {
      case 0:
        return 16;
      case 1:
        return 13;
      case 2:
        return 12;
    }
    return 20;
  }
}
