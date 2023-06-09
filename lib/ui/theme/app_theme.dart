import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class AppThemeImpl {
  Color get primaryColorLight => const Color.fromARGB(255, 43, 97, 209);
  Color get lightText => const Color.fromARGB(255, 48, 59, 82);
  Color get scaffoldBackgroundLight => const Color.fromARGB(255, 252, 253, 255);
  Color get cardColorLight => const Color.fromARGB(255, 255, 255, 255);

  static ThemeOptions? getOptions(BuildContext context) {
    var options = ThemeProvider.themeOf(context).options;
    if (options != null && options is ThemeOptions) {
      return options;
    }
    return null;
  }

  ChipThemeData chipThemeData(
      {required Color styleBackgroundColor,
      required Color textColor,
      required Color shadowColor,
      Color? selectedColor}) {
    return ChipThemeData(
      backgroundColor: styleBackgroundColor,
      labelStyle: TextStyle(
        color: textColor, // Set the text color to grey
      ),
      shadowColor: shadowColor,
      elevation: 7.5,
      padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 40),
      selectedColor: selectedColor,
    );
  }

  AppTheme get light {
    var primaryColor = primaryColorLight;
    return AppTheme(
      id: 'light',
      description: 'Light Mode',
      data: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Montserrat',
        primaryColor: primaryColor,
        iconTheme: ThemeData.light().iconTheme.copyWith(color: lightText),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return lightText; //<-- SEE HERE
              },
            ),
          ),
        ),
        scaffoldBackgroundColor: scaffoldBackgroundLight,
        splashFactory: InkRipple.splashFactory,
        appBarTheme: AppBarTheme(
          backgroundColor: scaffoldBackgroundLight,
        ),
        bottomNavigationBarTheme: ThemeData.light().bottomNavigationBarTheme.copyWith(
              selectedItemColor: primaryColor,
              backgroundColor: scaffoldBackgroundLight,
              selectedIconTheme: IconThemeData(color: primaryColor),
            ),
        shadowColor: Colors.black,
        expansionTileTheme: ThemeData.light().expansionTileTheme.copyWith(
              backgroundColor: scaffoldBackgroundLight,
              collapsedBackgroundColor: cardColorLight,
              iconColor: darkText,
              textColor: darkText,
            ),
        cardColor: cardColorLight,
        cardTheme: ThemeData.light().cardTheme.copyWith(
              shadowColor: const Color.fromARGB(20, 43, 97, 209),
              color: cardColorLight,
            ),
        indicatorColor: primaryColorDark,
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                decorationColor: Colors.white,
                fontSize: 24,
                color: lightText,
              ),
              titleMedium: TextStyle(
                decorationColor: Colors.white,
                fontSize: 20,
                color: lightText,
              ),
              titleSmall: TextStyle(
                decorationColor: Colors.white,
                fontSize: 16,
                color: lightText,
              ),
              headlineLarge: TextStyle(
                fontSize: 28,
                color: lightText,
                fontWeight: FontWeight.w600,
              ),
              headlineMedium: TextStyle(
                fontSize: 18,
                color: lightText,
                fontWeight: FontWeight.w600,
              ),
              headlineSmall: TextStyle(
                fontSize: 14,
                color: lightText,
                fontWeight: FontWeight.w600,
              ),
              bodyLarge: TextStyle(
                fontSize: 18,
                color: lightText,
              ),
              bodyMedium: TextStyle(
                fontSize: 14,
                color: lightText,
              ),
              bodySmall: TextStyle(
                fontSize: 12,
                color: lightText,
              ),
            ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            fontSize: 13,
            color: darkText,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          contentPadding: const EdgeInsets.all(5),
          isDense: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: primaryColorLight),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColorDark,
          foregroundColor: darkText,
        ),
        chipTheme: chipThemeData(
          styleBackgroundColor: Colors.transparent,
          textColor: Colors.grey,
          shadowColor: primaryColorLight.withOpacity(0.35),
        ),
      ),
      options: themeOptions,
    );
  }

  Color get primaryColorDark => const Color.fromARGB(255, 38, 86, 198);
  Color get darkText => const Color.fromARGB(255, 208, 210, 214);
  Color get scaffoldBackgroundDark => const Color.fromARGB(255, 20, 22, 41);
  Color get cardColorDark => const Color.fromARGB(255, 14, 16, 33);

  AppTheme get dark {
    var primaryColor = primaryColorDark;
    return AppTheme(
      id: 'dark',
      description: 'Dark Mode',
      data: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        primaryColor: primaryColorDark,
        iconTheme: ThemeData.dark().iconTheme.copyWith(color: darkText),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                return darkText;
              },
            ),
          ),
        ),
        scaffoldBackgroundColor: scaffoldBackgroundDark,
        splashFactory: InkRipple.splashFactory,
        appBarTheme: AppBarTheme(
          backgroundColor: scaffoldBackgroundDark,
        ),
        bottomNavigationBarTheme: ThemeData.dark().bottomNavigationBarTheme.copyWith(
              selectedItemColor: primaryColorDark,
              backgroundColor: scaffoldBackgroundDark,
              selectedIconTheme: IconThemeData(color: primaryColor),
            ),
        shadowColor: Colors.black,
        expansionTileTheme: ThemeData.dark().expansionTileTheme.copyWith(
              backgroundColor: scaffoldBackgroundDark,
              collapsedBackgroundColor: cardColorDark,
              iconColor: darkText,
              textColor: darkText,
            ),
        cardColor: cardColorDark,
        cardTheme: ThemeData.light().cardTheme.copyWith(
              shadowColor: const Color.fromARGB(40, 8, 8, 18),
              color: cardColorDark,
            ),
        indicatorColor: primaryColorDark,
        textTheme: ThemeData.dark().textTheme.copyWith(
              titleLarge: TextStyle(
                decorationColor: Colors.white,
                fontSize: 24,
                color: darkText,
              ),
              titleMedium: TextStyle(
                decorationColor: Colors.white,
                fontSize: 20,
                color: darkText,
              ),
              titleSmall: TextStyle(
                decorationColor: Colors.white,
                fontSize: 16,
                color: darkText,
              ),
              headlineLarge: TextStyle(
                fontSize: 28,
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
              headlineMedium: TextStyle(
                fontSize: 18,
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
              headlineSmall: TextStyle(
                fontSize: 14,
                color: darkText,
                fontWeight: FontWeight.w600,
              ),
              bodyLarge: TextStyle(
                fontSize: 18,
                color: darkText,
              ),
              bodyMedium: TextStyle(
                fontSize: 14,
                color: darkText,
              ),
              bodySmall: TextStyle(
                fontSize: 12,
                color: darkText,
              ),
            ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            fontSize: 13,
            color: darkText,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          contentPadding: const EdgeInsets.all(5),
          isDense: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: primaryColorDark),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColorDark,
          foregroundColor: darkText,
        ),
        chipTheme: chipThemeData(
          styleBackgroundColor: scaffoldBackgroundDark,
          textColor: darkText,
          shadowColor: Colors.black.withOpacity(0.35),
          selectedColor: primaryColorDark,
        ),
      ),
      options: themeOptions,
    );
  }

  ThemeOptions get themeOptions => ThemeOptions(
        titledCardIconColor: Colors.white,
        cardBorderRadius: 18.7,
      );
}

class ThemeOptions implements AppThemeOptions {
  final Color? titledCardIconColor;
  final double cardBorderRadius;
  final Color? cardOutlineColorDark;
  final Color? cardOutlineColorLight;
  final bool? cardGradient;
  final bool? titledCardIconShadow;

  Color? cardOutlineColor(BuildContext context) {
    return ThemeProvider.themeOf(context).id == 'dark' ? cardOutlineColorDark : cardOutlineColorLight;
  }

  List<BoxShadow>? getTitledCardIconShadow(BuildContext context) {
    return (titledCardIconShadow ?? true)
        ? [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(3, 3),
              color: ThemeProvider.themeOf(context).data.cardTheme.shadowColor!,
            ),
          ]
        : null;
  }

  ThemeOptions({
    required this.cardBorderRadius,
    this.titledCardIconColor,
    this.cardOutlineColorLight,
    this.cardOutlineColorDark,
    this.cardGradient,
    this.titledCardIconShadow,
  });
}
