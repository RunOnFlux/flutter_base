import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:tinycolor2/tinycolor2.dart';

class ExampleAppTheme extends AppThemeImpl {
  @override
  Color get primaryColorLight => const Color.fromARGB(255, 43, 97, 209);

  @override
  Color get lightText => const Color.fromARGB(255, 48, 59, 82);

  @override
  Color get primaryColorDark => const Color.fromARGB(255, 38, 86, 198);

  @override
  Color get darkText => const Color.fromARGB(255, 208, 210, 214);

  @override
  ThemeOptions get themeOptions => ThemeOptions(
        titledCardIconColor: Colors.transparent,
        cardBorderRadius: 18.7,
        cardOutlineColorDark: cardColorDark.lighten(20),
        cardOutlineColorLight: cardColorLight.darken(20),
        cardGradient: false,
        titledCardIconShadow: false,
      );
}
