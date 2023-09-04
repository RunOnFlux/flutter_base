import 'package:flutter/material.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_svg/svg.dart';

mixin MenuStyles {
  Widget buildImage(
    BuildContext context,
    Image? image,
    Color selectedColor,
    Color unselectedColor, {
    int level = 0,
    bool selected = false,
  }) {
    double size = iconSizeForLevel(level);
    return image != null
        ? SizedBox(
            height: size,
            width: size,
            child: image,
          )
        : const SizedBox();
  }

  Widget buildIcon(
    BuildContext context,
    IconData? icon,
    Color selectedColor,
    Color unselectedColor, {
    int level = 0,
    bool selected = false,
  }) {
    double size = iconSizeForLevel(level);
    return icon != null
        ? SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              size: size,
              color: selected ? selectedColor : unselectedColor,
            ),
          )
        : const SizedBox();
  }

  Widget buildAsset(String asset, Color selectedColor, Color unselectedColor, {int level = 0, bool selected = false}) {
    return SvgPicture.asset(
      asset,
      width: iconSizeForLevel(level),
      colorFilter: ColorFilter.mode(selected ? selectedColor : unselectedColor, BlendMode.srcIn),
    );
  }

  Widget buildIconWidget(
    AbstractRoute route,
    BuildContext context,
    int level,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
  ) {
    if (route.icon != null) {
      return buildIcon(
        context,
        route.icon,
        selectedColor,
        unselectedColor,
        selected: isSelected,
        level: level,
      );
    }
    if (route.image != null) {
      return buildImage(
        context,
        route.image,
        selectedColor,
        unselectedColor,
        level: level,
      );
    }
    if (route.asset != null) {
      return buildAsset(
        route.asset!,
        selectedColor,
        unselectedColor,
        selected: isSelected,
        level: level,
      );
    }
    return const SizedBox(
      width: 24,
      height: 24,
    );
  }

  Widget buildTitle(
    BuildContext context,
    String title,
    Color selectedColor,
    Color unselectedColor,
    int level, {
    bool selected = false,
  }) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: fontSizeForLevel(level),
            letterSpacing: 1,
            color: selected ? selectedColor : unselectedColor,
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

  double fontSizeForLevel(int level) {
    switch (level) {
      case 0:
        return 13;
      case 1:
        return 11;
      case 2:
        return 10;
    }
    return 20;
  }

  double iconSizeForLevel(int level) {
    switch (level) {
      case 0:
        return 24;
      case 1:
        return 20.5;
      case 2:
        return 17;
    }
    return 20;
  }
}
