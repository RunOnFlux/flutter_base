import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/widgets/logo.dart';
import 'package:flutter_base/ui/widgets/navbar/navbar.dart';
import 'package:flutter_base/ui/widgets/responsive_builder.dart';
import 'package:flutter_base/utils/settings.dart';
import 'package:go_router/go_router.dart';

class AppConfig {
  String? get banner => null;

  bool get hasTitleBar => false;

  bool get smallScreenScroll => true;

  bool checkSmallHeight(BuildContext context) {
    return context.isSmallHeight(600);
  }

  String getInitialRoute(Settings settings) {
    return settings.getString(Setting.initialRoute.name);
  }

  setInitialRoute(String route, Settings settings) {
    settings.setString(Setting.initialRoute.name, route);
  }

  String getWindowTitle(AppBodyState body, WindowTitle title) {
    return title.title;
  }

  List<Widget> buildTitleActionButtons(BuildContext context) {
    return [];
  }

  Widget? buildAppBarTitle(BuildContext context) {
    return null;
  }

  Widget? buildMenuHeader(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Logo(clickRedirectHomePage: true),
              SideBarButton(),
            ],
          ),
        ),
        Divider(),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget? buildMenuFooter(BuildContext context) {
    return null;
  }

  List<LocalizationsDelegate> get localizationDelegates => [];
  /*const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];*/

  Iterable<Locale> get supportedLocales => const [
        Locale('en', "US"),
      ];

  GoExceptionHandler? get routeExceptionHandler => (context, state, router) {
        router.go('/');
      };
}
