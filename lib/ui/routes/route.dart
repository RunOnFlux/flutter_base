import 'package:flutter/material.dart';

import '../widgets/app_screen.dart';

abstract class AbstractRoute {
  late String title;
  late IconData? icon;
  late Image? image;
}

class NavigationRoute implements AbstractRoute {
  String route;
  AppScreen? body;
  bool includeInMenu = false;
  List<PrivilegeLevel>? privilege;
  int? navBarIndex;
  Widget Function(BuildContext)? badge;

  NavigationRoute({
    required this.route,
    this.body,
    required this.title,
    this.includeInMenu = false,
    this.icon,
    this.image,
    this.privilege,
    this.navBarIndex,
    this.badge,
  });

  @override
  IconData? icon;

  @override
  String title;

  @override
  Image? image;
}

enum PrivilegeLevel {
  none('none'),
  user('user'),
  admin('admin'),
  fluxteam('fluxteam');

  const PrivilegeLevel(this.level);
  final String level;

  static PrivilegeLevel? fromString(String level) {
    List<PrivilegeLevel> levels = PrivilegeLevel.values;
    for (var element in levels) {
      if (element.level == level) return element;
    }
    return null;
  }
}

class RouteSet implements AbstractRoute {
  List<AbstractRoute> routes;

  RouteSet({
    required this.title,
    required this.routes,
    this.icon,
    this.image,
  });

  @override
  IconData? icon;

  @override
  String title;

  @override
  Image? image;
}
