import 'package:flutter/material.dart';
import 'package:flutter_base/ui/widgets/app_screen.dart';

abstract class AbstractRoute {
  final String title;
  final IconData? icon;
  final Image? image;
  final String? asset;
  final bool? active;

  final Widget? above;
  final Widget? below;
  Widget Function(BuildContext, Widget?)? badge;

  final List<PrivilegeLevel>? privilege;

  AbstractRoute({
    this.icon,
    this.image,
    this.asset,
    this.active,
    this.above,
    this.below,
    this.privilege,
    this.badge,
    required this.title,
  });
}

class ActionRoute extends AbstractRoute {
  Function(BuildContext context) action;

  ActionRoute({
    required super.title,
    required this.action,
    super.icon,
    super.image,
    super.asset,
    super.privilege,
    super.active,
    super.above,
    super.below,
  });
}

class NavigationRoute extends AbstractRoute {
  String route;
  String? initialLocation;
  AppContentScreen? body;
  bool includeInMenu = false;
  int? navBarIndex;

  NavigationRoute({
    required this.route,
    this.body,
    required super.title,
    this.includeInMenu = false,
    super.icon,
    super.image,
    super.asset,
    super.privilege,
    this.navBarIndex,
    super.badge,
    super.active,
    this.initialLocation,
    super.above,
    super.below,
  }) {
    body?.stateInfo.route = route;
  }

/*void go(GoRouter router) {
    Future.microtask(() {
      router.go(route);
      GetIt.I<ScreenInfo>().currentState = body!.stateInfo;
    });
  }*/
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

class RouteSet extends AbstractRoute {
  List<AbstractRoute> routes;

  RouteSet({
    required super.title,
    required this.routes,
    super.icon,
    super.image,
    super.asset,
    super.above,
    super.below,
  });
}
