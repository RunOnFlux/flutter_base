import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/gradients/gradient_divider.dart';
import 'package:flutter_base/ui/widgets/gradients/gradient_text.dart';
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

  // Example theme overriding
  /*@override
  AppTheme get light {
    return super.light.copyWith(
          id: 'light',
          description: 'Light Mode',
          data: super.light.data.copyWith(
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  foregroundColor: Colors.orange,
                ),
                primaryColor: Colors.green,
              ),
        );
  }*/

  @override
  ThemeOptions get themeOptions => ThemeOptions(
        titledCardIconColor: Colors.transparent,
        cardBorderRadius: 18.7,
        cardOutlineColorDark: cardColorDark.lighten(20),
        cardOutlineColorLight: cardColorLight.darken(20),
        cardGradient: false,
        titledCardIconShadow: false,
        appBackgroundColor: Colors.red,
        backgroundGradientEllipses: const [
          (Color.fromRGBO(0, 117, 255, 0.2), Offset(-700, -500)),
          (Color.fromRGBO(64, 152, 255, 0.2), Offset(400, -900)),
          (Color.fromRGBO(64, 152, 255, 0.2), Offset(991, 620)),
        ],
      )..authOptions = AuthOptions(
          getImage: (context) => Image.asset(
            'assets/images/webp/pouw_background.webp',
            fit: BoxFit.cover,
          ),
          rightChild: (context) => const FractionallySizedBox(
            widthFactor: 0.75,
            child: Center(
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Revolutionizing Technology',
                      textAlign: TextAlign.center,
                      softWrap: false,
                      maxLines: 3,
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  GradientDivider(
                    width: 100,
                    margin: EdgeInsets.symmetric(vertical: 10),
                  ),
                  GradientText(
                    'AuthScreen Example',
                    style: TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ),
          ),
        );
}
