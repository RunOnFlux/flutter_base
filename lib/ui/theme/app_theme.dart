import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class AppThemeImpl {
  Color get primaryColorLight {
    print('get base primaryColorLight');
    return const Color.fromARGB(255, 43, 97, 209);
  }

  Color get lightText => const Color.fromARGB(255, 48, 59, 82);

  static ThemeOptions? getOptions(BuildContext context) {
    var options = ThemeProvider.themeOf(context).options;
    if (options != null && options is ThemeOptions) {
      return options;
    }
    return null;
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
        scaffoldBackgroundColor: const Color.fromARGB(255, 252, 253, 255),
        splashFactory: InkRipple.splashFactory,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 252, 253, 255),
        ),
        bottomNavigationBarTheme: ThemeData.light().bottomNavigationBarTheme.copyWith(
              selectedItemColor: primaryColor,
              backgroundColor: const Color.fromARGB(255, 248, 248, 248),
              selectedIconTheme: IconThemeData(color: primaryColor),
            ),
        shadowColor: Colors.black,
        expansionTileTheme: ThemeData.light().expansionTileTheme.copyWith(
              backgroundColor: const Color.fromARGB(255, 248, 248, 248),
              collapsedBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
              iconColor: darkText,
              textColor: darkText,
            ),
        cardColor: const Color.fromARGB(255, 255, 255, 255),
        cardTheme: ThemeData.light().cardTheme.copyWith(
              shadowColor: const Color.fromARGB(20, 43, 97, 209),
              color: Colors.white,
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
          contentPadding: EdgeInsets.all(5),
          isDense: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: primaryColorDark),
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: primaryColorDark, foregroundColor: darkText),
      ),
      options: ThemeOptions(titledCardIconColor: Colors.white, cardBorderRadius: 18.7),
    );
  }

  Color get primaryColorDark => const Color.fromARGB(255, 38, 86, 198);
  Color get darkText => const Color.fromARGB(255, 208, 210, 214);

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
        scaffoldBackgroundColor: const Color.fromARGB(255, 20, 22, 41),
        splashFactory: InkRipple.splashFactory,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 20, 22, 41),
        ),
        bottomNavigationBarTheme: ThemeData.dark().bottomNavigationBarTheme.copyWith(
              selectedItemColor: primaryColorDark,
              backgroundColor: const Color.fromARGB(255, 20, 22, 41),
              selectedIconTheme: IconThemeData(color: primaryColor),
            ),
        shadowColor: Colors.black,
        expansionTileTheme: ThemeData.dark().expansionTileTheme.copyWith(
              backgroundColor: const Color.fromARGB(255, 20, 22, 41),
              collapsedBackgroundColor: const Color.fromARGB(255, 14, 16, 33),
              iconColor: darkText,
              textColor: darkText,
            ),
        cardColor: const Color.fromARGB(255, 14, 16, 33),
        cardTheme: ThemeData.light().cardTheme.copyWith(
              shadowColor: const Color.fromARGB(40, 8, 8, 18),
              color: const Color.fromARGB(255, 14, 16, 33),
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
      ),
      options: themeOptions,
    );
  }

  ThemeOptions get themeOptions => ThemeOptions(titledCardIconColor: Colors.white, cardBorderRadius: 18.7);
}

class ThemeOptions implements AppThemeOptions {
  final Color? titledCardIconColor;
  final double cardBorderRadius;

  ThemeOptions({this.titledCardIconColor, required this.cardBorderRadius});
}
