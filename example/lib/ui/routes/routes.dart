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
        title: 'Home',
        icon: Icons.home,
        includeInMenu: true,
      ),
      ActionRoute(
        title: 'Action',
        action: () {
          debugPrint('do something!!');
        },
        route: '/action',
        icon: Icons.add,
      )
    ];
    return routes;
  }
}
