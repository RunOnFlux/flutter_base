import 'package:flutter/material.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/routes/routes.dart';
import 'package:flutter_base/ui/widgets/popup_message.dart';
import 'package:flutter_base_example/ui/screens/home/home_screen.dart';
import 'package:flutter_base_example/ui/screens/tabs/tabbed_screen.dart';

class ExampleAppRouter extends AppRouter {
  ExampleAppRouter._p() {
    routes = buildRoutes();
  }
  static final ExampleAppRouter _instance = ExampleAppRouter._p();
  factory ExampleAppRouter() => _instance;

  @override
  List<AbstractRoute> buildRoutes() {
    final routes = <AbstractRoute>[
      NavigationRoute(
        route: '/',
        body: HomeScreen(),
        title: 'Workers',
        asset: 'assets/images/svg/workers_icon.svg',
        includeInMenu: true,
      ),
      NavigationRoute(
        route: '/disabled',
        body: HomeScreen(),
        title: 'Disabled',
        icon: Icons.disabled_by_default_outlined,
        includeInMenu: true,
        active: false,
      ),
      RouteSet(
        title: 'Sub Menu',
        asset: 'assets/images/svg/mining_icon.svg',
        routes: [
          NavigationRoute(
            route: '/1',
            body: HomeScreen(),
            title: '1',
            icon: Icons.access_alarm_outlined,
            includeInMenu: true,
          ),
          NavigationRoute(
            route: '/2',
            body: HomeScreen(),
            title: '2',
            icon: Icons.back_hand_outlined,
            includeInMenu: true,
          ),
          NavigationRoute(
            route: '/3',
            body: HomeScreen(),
            title: '3',
            icon: Icons.three_g_mobiledata_outlined,
            includeInMenu: true,
          ),
        ],
      ),
      NavigationRoute(
        route: '/tabs',
        title: 'Tabbed',
        body: const ExampleTabsScreen(),
        icon: Icons.tab_outlined,
        includeInMenu: true,
      ),
      NavigationRoute(
        route: '/tabs/1',
        title: 'Tabbed 1',
        body: const ExampleTabsScreen(
          initialPage: ExampleTabsScreen.one,
        ),
      ),
      NavigationRoute(
        route: '/tabs/2',
        title: 'Tabbed 2',
        body: const ExampleTabsScreen(
          initialPage: ExampleTabsScreen.two,
        ),
      ),
      NavigationRoute(
        route: '/tabs/3',
        title: 'Tabbed 3',
        body: const ExampleTabsScreen(
          initialPage: ExampleTabsScreen.three,
        ),
      ),
      ActionRoute(
        title: 'Action',
        action: (BuildContext context) {
          debugPrint('do something!!');
          const PopupMessage(message: 'Do Something!!').show(context);
        },
        route: '/action',
        icon: Icons.add,
      ),
    ];
    return routes;
  }
}
