import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class AppThemeImpl {
  Color get primaryColorLight => const Color.fromARGB(255, 43, 97, 209);
  Color get lightText => const Color.fromARGB(255, 48, 59, 82);
  Color get scaffoldBackgroundLight => const Color.fromARGB(255, 252, 253, 255);
  Color get cardColorLight => const Color.fromARGB(255, 255, 255, 255);

  static ThemeOptions getOptions(BuildContext context) {
    var options = ThemeProvider.themeOf(context).options;
    return options as ThemeOptions;
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          foregroundColor: Color(0xFF303B52),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontFamily: 'Montserrat',
            color: Color(0xFF303B52),
            fontWeight: FontWeight.w700,
          ),
        ),
        bottomNavigationBarTheme: ThemeData.light().bottomNavigationBarTheme.copyWith(
              selectedItemColor: primaryColor,
              backgroundColor: scaffoldBackgroundLight,
              selectedIconTheme: IconThemeData(color: primaryColor),
            ),
        brightness: Brightness.light,
        canvasColor: Colors.white,
        cardColor: cardColorLight,
        cardTheme: ThemeData.light().cardTheme.copyWith(
              shadowColor: const Color.fromARGB(20, 43, 97, 209),
              color: cardColorLight,
            ),
        checkboxTheme: CheckboxThemeData(
          side: MaterialStateBorderSide.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return const BorderSide(
                  color: Color(0xFF0255FE),
                  width: 1,
                );
              } else {
                return const BorderSide(
                  color: Color(0xFFD0D5DD),
                  width: 1,
                );
              }
            },
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          fillColor: MaterialStateProperty.all(Colors.transparent),
          checkColor: MaterialStateProperty.all(const Color(0xFF0255FE)),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color.fromARGB(255, 230, 233, 238),
          disabledColor: Colors.white,
          selectedColor: const Color(0xFF2463EB),
          secondarySelectedColor: const Color(0xFF2463EB),
          padding: const EdgeInsets.all(8),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide.none),
          secondaryLabelStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          brightness: Brightness.light,
          shadowColor: primaryColorLight.withOpacity(0.35),
          labelStyle: const TextStyle(
            color: Colors.grey, // Set the text color to grey
          ),
          elevation: 7.5,
        ),
        colorScheme: ColorScheme.fromSeed(
          surface: Colors.white,
          surfaceTint: Colors.transparent,
          seedColor: const Color(0xFF2463EB),
          primary: const Color(0xFF2B61D1),
          secondary: const Color(0xFF0255FE),
          background: const Color(0xFFFAFBFC),
        ),
        dataTableTheme: DataTableThemeData(
          checkboxHorizontalMargin: 15,
          dataRowColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return const Color(0xffFFFBF5);
              }
              if (states.contains(MaterialState.hovered)) {
                return const Color.fromARGB(255, 248, 249, 250);
              }
              if (states.contains(MaterialState.pressed)) {
                return const Color.fromARGB(255, 242, 243, 245);
              }
              return null;
            },
          ),
        ),
        dialogTheme: const DialogTheme(
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontFamily: 'Montserrat',
            color: Color(0xFF303B52),
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 0.6,
              color: Color.fromRGBO(184, 195, 225, 0.5),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
        dividerColor: const Color(0xFFEAEAEA),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE9EAF3),
          thickness: 1,
        ),
        drawerTheme: const DrawerThemeData(
          surfaceTintColor: Colors.white,
          scrimColor: Colors.transparent,
          shape: Border(
            right: BorderSide(width: 1, color: Color(0xffE9EAF3)),
            bottom: BorderSide(width: 1, color: Color(0xffE9EAF3)),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          width: 300,
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          menuStyle: const MenuStyle(
            elevation: MaterialStatePropertyAll(2),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
            backgroundColor: MaterialStatePropertyAll(
              Color(0xFFEBEEFF),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: const Color.fromARGB(255, 247, 248, 252),
            suffixIconColor: const Color(0xff1E2329),
            disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(184, 195, 225, 0.5), width: 1),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(184, 195, 225, 0.5), width: 1),
                borderRadius: BorderRadius.circular(10)),
            outlineBorder: const BorderSide(color: Color.fromRGBO(184, 195, 225, 0.5), width: 1),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(184, 195, 225, 0.5), width: 1),
                borderRadius: BorderRadius.circular(10)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromRGBO(184, 195, 225, 0.5), width: 1),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // change background color of button
            backgroundColor: primaryColorLight, // change text color of button
            textStyle: TextStyle(
              fontSize: 14,
              color: lightText,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        expansionTileTheme: ThemeData.light().expansionTileTheme.copyWith(
              backgroundColor: scaffoldBackgroundLight,
              collapsedBackgroundColor: cardColorLight,
              iconColor: darkText,
              textColor: darkText,
            ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColorDark,
          foregroundColor: darkText,
        ),
        fontFamily: 'Montserrat',
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
        indicatorColor: primaryColorDark,
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
        primaryColor: primaryColor,
        primaryColorDark: const Color(0xFF303B52),
        primaryColorLight: const Color(0xFFEBEEFF),
        scaffoldBackgroundColor: scaffoldBackgroundLight,
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(const Color(0xFFB8C3E1)),
          trackColor: MaterialStateProperty.all(const Color(0xFFEBEEFF)),
          crossAxisMargin: 4,
          mainAxisMargin: 4,
          radius: const Radius.circular(18),
          thickness: MaterialStateProperty.all(4),
        ),
        shadowColor: Colors.black,
        splashFactory: InkRipple.splashFactory,
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
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color.fromRGBO(184, 195, 225, 0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        useMaterial3: true,
      ),
      options: themeOptions,
    );
  }

  Color get primaryColorDark => const Color.fromARGB(255, 27, 103, 255);
  Color get darkText => const Color.fromARGB(255, 255, 255, 255);
  //Color get scaffoldBackgroundDark => const Color.fromARGB(255, 20, 22, 41);
  Color get cardColorDark => const Color.fromARGB(29, 56, 56, 61);

  AppTheme get dark => AppTheme(
        id: 'dark',
        description: 'Dark Mode',
        data: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          bottomNavigationBarTheme: ThemeData.dark().bottomNavigationBarTheme.copyWith(
                selectedItemColor: primaryColorDark,
                backgroundColor: Colors.transparent,
                selectedIconTheme: IconThemeData(color: primaryColorDark),
              ),
          brightness: Brightness.dark,
          cardColor: cardColorDark,
          cardTheme: ThemeData.light().cardTheme.copyWith(
                shadowColor: const Color.fromARGB(40, 8, 8, 18),
                color: cardColorDark,
              ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            fillColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 13, 126, 255),
            ),
            checkColor: MaterialStateProperty.all(Colors.white),
          ),
          chipTheme: chipThemeData(
            styleBackgroundColor: Colors.transparent,
            textColor: darkText,
            shadowColor: Colors.black.withOpacity(0.35),
            selectedColor: primaryColorDark,
          ),
          colorScheme: const ColorScheme.dark(
            surfaceTint: Colors.transparent,
            primary: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            background: Color(0xff070F1E),
            secondary: Color.fromARGB(255, 13, 126, 255),
          ),
          dialogTheme: const DialogTheme(
            elevation: 2,
            backgroundColor: Color.fromRGBO(20, 21, 41, 1),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 0.6,
                color: Color.fromRGBO(46, 142, 255, 0.20),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
          ),
          dividerColor: const Color.fromRGBO(184, 195, 225, 0.25),
          dividerTheme: const DividerThemeData(
            color: Color.fromRGBO(184, 195, 225, 0.25),
            thickness: 1,
          ),
          drawerTheme: const DrawerThemeData(
            surfaceTintColor: Colors.black,
            scrimColor: Colors.transparent,
            // borderside only right

            shape: Border(
                right: BorderSide(width: 1, color: _darkBorderColor),
                bottom: BorderSide(width: 1, color: _darkBorderColor)),
            backgroundColor: Colors.transparent,
            elevation: 2,
            width: 300,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // change background color of button
              backgroundColor: primaryColorDark, // change text color of button
              textStyle: TextStyle(
                fontSize: 14,
                color: lightText,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          expansionTileTheme: ThemeData.dark().expansionTileTheme.copyWith(
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: cardColorDark,
                iconColor: darkText,
                textColor: darkText,
              ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: primaryColorDark,
            foregroundColor: darkText,
          ),
          fontFamily: 'Montserrat',
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
          indicatorColor: primaryColorDark,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(
              fontSize: 13,
              color: darkText,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: primaryColorDark,
              ),
            ),
            contentPadding: const EdgeInsets.all(5),
            isDense: true,
          ),
          primaryColor: primaryColorDark,
          primaryColorLight: const Color(0xFF1F283A),
          primaryColorDark: const Color(0xFF2A354E),
          scaffoldBackgroundColor: Colors.transparent,
          shadowColor: Colors.black,
          splashFactory: InkRipple.splashFactory,
          switchTheme: SwitchThemeData(
            thumbColor: MaterialStateProperty.all(Colors.white),
            trackColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 13, 126, 255),
            ),
          ),
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
          useMaterial3: true,
        ),
        options: themeOptions,
      );

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
  final Color? appBackgroundColor;
  late List<(Color, Offset)> backgroundGradientEllipses;
  late List<Color> bgDarkGradientColors;
  late List<Color> bgLightGradientColors;

  Color? cardOutlineColor(BuildContext context) {
    return Theme.of(context).isDark ? cardOutlineColorDark : cardOutlineColorLight;
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

  LinearGradient? backgroundGradient(BuildContext context) {
    if (Theme.of(context).isLight) {
      return null;
    }
    return LinearGradient(
        stops: const [0.35, 1],
        tileMode: TileMode.decal,
        colors: bgDarkGradientColors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
  }

  Gradient ellipsisGradient(BuildContext context, Color color) {
    return RadialGradient(
        radius: 0.4,
        tileMode: TileMode.decal,
        colors: Theme.of(context).isDark ? [color, Colors.transparent] : bgLightGradientColors,
        stops: const [0.25, 1],
        center: Alignment.center);
  }

  LinearGradient textLinearGradient(BuildContext context) {
    return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: Theme.of(context).isDark
            ? [
                const Color(0xFFD2EEFF),
                const Color(0xFF5CBDFF),
                const Color(0xFF528EFC),
                const Color(0xFF8B94F3),
                const Color(0xFFA08FCE)
              ]
            : [
                const Color(0xFFD2EEFF),
                const Color(0xFF5CBDFF),
                const Color(0xFF528EFC),
                const Color(0xFF8B94F3),
                const Color(0xFFA08FCE)
              ],
        stops: const [0, 0.2344, 0.5104, 0.724, 1]);
  }

  ThemeOptions({
    required this.cardBorderRadius,
    this.titledCardIconColor,
    this.cardOutlineColorLight,
    this.cardOutlineColorDark,
    this.cardGradient,
    this.titledCardIconShadow,
    this.appBackgroundColor,
    this.backgroundGradientEllipses = const [
      (Color.fromRGBO(0, 117, 255, 0.2), Offset(-700, -500)),
      (Color.fromRGBO(64, 152, 255, 0.2), Offset(400, -900)),
      (Color.fromRGBO(64, 152, 255, 0.2), Offset(991, 620)),
    ],
    this.bgDarkGradientColors = const [
      Color.fromARGB(255, 9, 19, 43),
      Color.fromARGB(255, 6, 13, 26),
    ],
    this.bgLightGradientColors = const [
      Colors.white,
      Colors.white,
    ],
  });
}

extension ThemeBits on ThemeData {
  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;

  Color get borderColor => isDark ? _darkBorderColor : _lightBorderColor;
  Color get percentColor => isDark ? _darkPercentColor : _lightPercentColor;
  Color get headingRowColor => isDark ? _headingRowDark : _headingRownLight;
  Color get tileColor => isDark ? _headingRowDark : const Color(0xFF2463EB);
  Color get sysInfoColor => isDark ? _systemInfoDark : _systemInfoLight;
  List<Color> get menuColors => [const Color(0xFFB8C3E1), const Color.fromARGB(255, 242, 243, 248)];
  Color get selectedMenuItem => const Color.fromRGBO(43, 97, 209, 0.05);
  Color get positiveColor => isDark ? _dPositiveColor : _lPositiveColor;
  Color get colorBarrier => isDark ? Colors.black12 : Colors.black45;
  BoxShadow get shadow => isDark ? _defaultDarkShadowColor : _defaultLightShadowColor;
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

const Color _warningColor = Color(0xFFFFCB2D);

const Color _lPositiveColor = Color(0xFF12B76A);
const Color _dPositiveColor = Color.fromARGB(153, 16, 204, 101);

const Color _dLightPositiveColor = Color.fromARGB(255, 19, 252, 143);
const Color _lLightPositiveColor = Color(0xFFECFDF3);

const Color _lightBorderColor = Color(0xFFDBE1F0);

const Color _darkBorderColor = Color.fromRGBO(184, 195, 255, 0.25);

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

class AuthOptions {
  final Image Function(BuildContext) getImage;
  final Widget Function(BuildContext) rightChild;

  AuthOptions({
    required this.getImage,
    required this.rightChild,
  });
}
