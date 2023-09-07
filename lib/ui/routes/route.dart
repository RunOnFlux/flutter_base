import 'package:flutter/material.dart';
import 'package:flutter_base/ui/widgets/app_screen.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

abstract class AbstractRoute {
  late String title;
  late IconData? icon;
  late Image? image;
  late String? asset;
  late bool? active;
}

class ActionRoute extends NavigationRoute {
  Function(BuildContext context) action;

  ActionRoute({
    required super.title,
    required this.action,
    required super.route,
    super.icon,
    super.image,
    super.asset,
    super.privilege,
    super.active,
  });
}

class NavigationRoute implements AbstractRoute {
  String route;
  AppContentScreen? body;
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
    this.asset,
    this.privilege,
    this.navBarIndex,
    this.badge,
    this.active,
  });

  @override
  IconData? icon;

  @override
  String title;

  @override
  Image? image;

  @override
  String? asset;

  @override
  bool? active;

  void go(GoRouter router) {
    Future.microtask(() {
      router.go(route);
      GetIt.I<ScreenInfo>().currentState = body!.stateInfo;
    });
  }
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
    this.asset,
  });

  @override
  IconData? icon;

  @override
  String title;

  @override
  Image? image;

  @override
  String? asset;

  @override
  bool? active;
}
