import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';

class ExampleAppTheme extends AppThemeImpl {
  @override
  Color get primaryColorLight => const Color.fromARGB(255, 243, 97, 209);

  @override
  Color get lightText => const Color.fromARGB(255, 248, 59, 82);

  @override
  Color get primaryColorDark => const Color.fromARGB(255, 238, 86, 198);

  @override
  Color get darkText => const Color.fromARGB(255, 28, 210, 214);

  @override
  ThemeOptions get themeOptions => ThemeOptions(titledCardIconColor: Colors.transparent, cardBorderRadius: 18.7);
}
