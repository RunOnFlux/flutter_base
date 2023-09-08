/*import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/routes/routes.dart';
import 'package:flutter_base/ui/widgets/scaffold/superscaffold.dart';
import 'package:flutter_base/ui/widgets/sidemenu/menu_category.dart';
import 'package:flutter_base/ui/widgets/sidemenu/menu_item.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SideMenuDrawer extends StatelessWidget with GetItMixin {
  final AppRouter router;
  final AppConfig config;
  final AppBodyState body;

  SideMenuDrawer({
    required this.router,
    required this.config,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PrivilegeLevel? privilege;
    if (GetIt.instance.isRegistered<LoginState>()) {
      privilege = watchOnly((LoginState state) => state.privilege);
    }
    return SizedBox(
      width: kDrawerWidth,
      child: Drawer(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        child: SafeArea(
          child: Column(
            children: [
              config.buildMenuHeader(context) ?? Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildMenu(context, privilege ?? PrivilegeLevel.none),
                      ],
                    ),
                  ),
                ),
              ),
              config.buildMenuFooter(context) ?? Container(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMenu(BuildContext context, PrivilegeLevel privilegeLevel) {
    List<AbstractRoute> routes = router.buildRoutes();
    List<Widget> menu = <Widget>[];
    for (AbstractRoute r in routes) {
      _buildMenuForRoute(r, menu, 0, privilegeLevel);
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
    } else if (r is ActionRoute) {
      if (r.privilege != null && r.includeInMenu) {
        PrivilegeLevel currentLevel = privilege;
        for (var privilege in r.privilege!) {
          if (privilege == currentLevel) {
            menu.add(
              FunctionMenuItem(
                route: r,
                level: level,
              ),
            );
            continue;
          }
        }
      } else {
        menu.add(
          FunctionMenuItem(
            route: r,
            level: level,
          ),
        );
      }
    }
  }
}
*/
