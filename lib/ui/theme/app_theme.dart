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

  AppTheme get dark => AppTheme(
        id: 'dark',
        description: 'Dark Mode',
        data: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          brightness: Brightness.dark,
          cardColor: const Color(0xff050B16),
          cardTheme: ThemeData.light().cardTheme.copyWith(
                shadowColor: const Color.fromARGB(40, 8, 8, 18),
                color: const Color(0xff050B16),
              ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            fillColor: MaterialStateProperty.all(const Color.fromARGB(255, 13, 126, 255)),
            checkColor: MaterialStateProperty.all(Colors.white),
          ),
          colorScheme: const ColorScheme.dark(
              surfaceTint: Colors.transparent,
              primary: Colors.white,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              background: Color(0xff070F1E),
              secondary: Color.fromARGB(255, 13, 126, 255)),
          dialogTheme: const DialogTheme(
              elevation: 2,
              backgroundColor: Color.fromRGBO(20, 21, 41, 1),
              shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.6, color: Color.fromRGBO(46, 142, 255, 0.20)),
                  borderRadius: BorderRadius.all(Radius.circular(8)))),
          drawerTheme: const DrawerThemeData(
              surfaceTintColor: Colors.black,
              scrimColor: Colors.transparent,
              // borderside only right

              shape: Border(
                  right: BorderSide(width: 1, color: _darkBorderColor),
                  bottom: BorderSide(width: 1, color: _darkBorderColor)),
              backgroundColor: Colors.transparent,
              elevation: 2,
              width: 300),
          fontFamily: 'Montserrat',
          primaryColor: const Color.fromARGB(255, 27, 103, 255),
          primaryColorLight: const Color(0xFF1F283A),
          primaryColorDark: const Color(0xFF2A354E),
          scaffoldBackgroundColor: Colors.transparent,
          shadowColor: Colors.black,
          switchTheme: SwitchThemeData(
              thumbColor: MaterialStateProperty.all(Colors.white),
              trackColor: MaterialStateProperty.all(const Color.fromARGB(255, 13, 126, 255))),
          textTheme: ThemeData.dark().textTheme
            ..copyWith(
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
          useMaterial3: true,
        ),
      );

  AppTheme get _dark {
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
        drawerTheme: const DrawerThemeData(
          surfaceTintColor: Colors.black,
          scrimColor: Colors.transparent,
          // borderside only right

          shape: Border(
            right: BorderSide(width: 1, color: _darkBorderColor),
            bottom: BorderSide(width: 1, color: _darkBorderColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 2,
          width: 300,
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

extension ThemeBits on ThemeData {
  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;
  Color get borderColor => isDark ? _darkBorderColor : _lightBorderColor;

  Color get background => isDark ? Colors.transparent : Colors.white;
  Color get percentColor => isDark ? _darkPercentColor : _lightPercentColor;
  Color get headingRowColor => isDark ? _headingRowDark : _headingRownLight;
  Color get tileColor => isDark ? _headingRowDark : const Color(0xFF2463EB);
  Color get sysInfoColor => isDark ? _systemInfoDark : _systemInfoLight;

  LinearGradient? get backgroundGradient {
    if (isLight) {
      return null;
    }
    return const LinearGradient(
        stops: [0.35, 1],
        tileMode: TileMode.decal,
        colors: _bgDarkGradientColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
  }

  Gradient ellipsisGradient(Color color) {
    return RadialGradient(
        radius: 0.4,
        tileMode: TileMode.decal,
        colors: isDark ? [color, Colors.transparent] : _bgLightGradientColors,
        stops: const [0.25, 1],
        center: Alignment.center);
  }
}

const Color kBestScoreColor = Colors.purpleAccent;

const Color _systemInfoDark = Color.fromARGB(255, 58, 121, 255);
const Color _systemInfoLight = Colors.black;

const Color _averageLight = Color.fromRGBO(0, 152, 3, 1);
const Color _yourLight = Color(0xff2B61D1);

const Color _averageDark = Color.fromRGBO(0, 152, 3, 1);
const Color _yourDark = Color.fromARGB(255, 16, 48, 231);

const Color _headingRowDark = Color.fromARGB(255, 36, 46, 71);
const Color _headingRownLight = Color(0xFFEBEEFF);
// const _lightGradient2 = <Color>[
//   Color.fromARGB(51, 20, 118, 255),
//   Color.fromARGB(165, 95, 20, 255),
//   Color.fromARGB(129, 255, 20, 161)
// ];

const _lightGradient2 = <Color>[
  Color.fromARGB(230, 43, 98, 209),
  Color.fromARGB(230, 21, 147, 201),
  Color.fromARGB(230, 81, 241, 252)
];
const _darkGradient2 = <Color>[
  Color.fromARGB(230, 43, 98, 209),
  Color.fromARGB(230, 21, 147, 201),
  Color.fromARGB(230, 81, 241, 252)
];
const Color _darkPercentColor = Colors.white;
const Color _lightPercentColor = Color(0xff747EB6);
const _bgLightGradientColors = [Colors.white, Colors.white];
const _bgDarkGradientColors = [Color.fromARGB(255, 9, 19, 43), Color.fromARGB(255, 6, 13, 26)];

const Color _warningColor = Color(0xFFFFCB2D);

const Color _lPositiveColor = Color(0xFF12B76A);
const Color _dPositiveColor = Color.fromARGB(153, 16, 204, 101);

const Color _dLightPositiveColor = Color.fromARGB(255, 19, 252, 143);
const Color _lLightPositiveColor = Color(0xFFECFDF3);

const Color _lightBorderColor = Color(0xFFDBE1F0);

const Color _darkBorderColor = Color.fromRGBO(46, 142, 255, 0.20);

const BoxShadow _defaultLightShadowColor = BoxShadow(
  color: Color.fromARGB(255, 231, 236, 247),
  offset: Offset(3.7480709552764893, 3.7480709552764893),
  blurRadius: 18.7403564453125,
  spreadRadius: 1.8740354776382446,
);

const BoxShadow _defaultDarkShadowColor = BoxShadow(
  color: Color.fromARGB(108, 0, 0, 0),
  offset: Offset(3.7480709552764893, 3.7480709552764893),
  blurRadius: 18.7403564453125,
  spreadRadius: 1.8740354776382446,
);
