import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/routes/routes.dart';
import 'package:flutter_base/ui/widgets/scaffold/superscaffold.dart';
import 'package:flutter_base/ui/widgets/sidemenu/menu_category.dart';
import 'package:flutter_base/ui/widgets/sidemenu/menu_item.dart';

class SideMenuDrawer extends StatelessWidget {
  final AppRouter router;
  final AppConfig config;
  final AppBodyState body;

  const SideMenuDrawer({
    required this.router,
    required this.config,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kDrawerWidth,
      child: Drawer(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        child: SafeArea(
          child: Column(
            children: [
              config.buildMenuHeader(body, context) ?? Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildMenu(context),
                      ],
                    ),
                  ),
                ),
              ),
              config.buildMenuFooter(body, context) ?? Container(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMenu(BuildContext context) {
    List<AbstractRoute> routes = router.buildRoutes();
    List<Widget> menu = <Widget>[];
    for (AbstractRoute r in routes) {
      _buildMenuForRoute(r, menu, 0, PrivilegeLevel.none);
    }
    return menu;
  }

  _buildMenuForRoute(AbstractRoute r, List<Widget> menu, int level, PrivilegeLevel privilege) {
    if (r is NavigationRoute && r.includeInMenu) {
      if (r.privilege != null) {
        PrivilegeLevel currentLevel = privilege;
        for (var privilege in r.privilege!) {
          if (privilege == currentLevel) {
            menu.add(
              NavigationMenuItem(
                route: r,
                level: level,
              ),
            );
            continue;
          }
        }
      } else {
        menu.add(
          NavigationMenuItem(
            route: r,
            level: level,
          ),
        );
      }
    } else if (r is RouteSet) {
      List<Widget> children = <Widget>[];
      for (AbstractRoute rr in r.routes) {
        _buildMenuForRoute(rr, children, level + 1, privilege);
      }
      menu.add(
        SideMenuCategory(
          route: r,
          level: level,
          children: children,
        ),
      );
    }
  }
}
