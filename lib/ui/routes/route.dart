import 'package:flutter/material.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
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

  GlobalKey? showcaseKey;
  String? showcaseDescription;

  AbstractRoute({
    this.icon,
    this.image,
    this.asset,
    this.active,
    this.above,
    this.below,
    this.privilege,
    this.badge,
    this.showcaseKey,
    this.showcaseDescription,
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
    super.showcaseKey,
    super.showcaseDescription,
  });
}

class NavigationRoute extends AbstractRoute {
  String route;
  String? initialLocation;
  AppContentScreen? body;
  bool includeInMenu = false;
  int? navBarIndex;
  List<NavigatorObserver>? observers;

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
    this.observers,
    super.showcaseKey,
    super.showcaseDescription,
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
    super.showcaseKey,
    super.showcaseDescription,
  });
}
