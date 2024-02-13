import 'package:flutter/material.dart';

import 'route.dart';

abstract class AppRouter {
  List<AbstractRoute> routes = [];

  List<AbstractRoute> buildRoutes(BuildContext context);

  List<NavigationRoute> getNavigationRoutes(BuildContext context) {
    List<AbstractRoute> allRoutes = buildRoutes(context);
    List<NavigationRoute> navRoutes = <NavigationRoute>[];
    for (AbstractRoute r in allRoutes) {
      _addNavigationRoutesFrom(r, navRoutes);
    }
    return navRoutes;
  }

  _addNavigationRoutesFrom(AbstractRoute r, List<NavigationRoute> routes) {
    if (r is NavigationRoute) {
      routes.add(r);
    } else if (r is RouteSet) {
      for (AbstractRoute rr in r.routes) {
        _addNavigationRoutesFrom(rr, routes);
      }
    }
  }

  AbstractRoute? findRoute(String route) {
    for (AbstractRoute r in routes) {
      if (r is NavigationRoute) {
        if (r.route == route) {
          return r;
        }
      }
    }
    return null;
  }
}
