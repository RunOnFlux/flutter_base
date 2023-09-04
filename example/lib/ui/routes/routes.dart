import 'package:flutter/material.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/routes/routes.dart';
import 'package:flutter_base_example/ui/screens/home/home_screen.dart';

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
        icon: Icons.home,
        includeInMenu: true,
        active: false,
      ),
      RouteSet(
        title: 'Workers',
        asset: 'assets/images/svg/workers_icon.svg',
        routes: [
          NavigationRoute(
            route: '/1',
            body: HomeScreen(),
            title: '1',
            icon: Icons.home,
            includeInMenu: true,
          ),
          NavigationRoute(
            route: '/2',
            body: HomeScreen(),
            title: '2',
            icon: Icons.home,
            includeInMenu: true,
          ),
          NavigationRoute(
            route: '/3',
            body: HomeScreen(),
            title: '3',
            icon: Icons.home,
            includeInMenu: true,
          ),
        ],
      ),
      ActionRoute(
        title: 'Action',
        action: () {
          debugPrint('do something!!');
        },
        route: '/action',
        icon: Icons.add,
      ),
    ];
    return routes;
  }
}
