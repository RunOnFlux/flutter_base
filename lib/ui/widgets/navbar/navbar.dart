import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/ui/app/config/app_config.dart';
import 'package:flutter_base/ui/app/main_app_screen.dart';
import 'package:flutter_base/ui/app/scope/app_config_scope.dart';
import 'package:flutter_base/ui/app/scope/app_router_scope.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/navbar/footer.dart';
import 'package:flutter_base/ui/widgets/sidemenu/menu_category.dart';
import 'package:flutter_base/ui/widgets/sidemenu/menu_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'menu.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerScope = AppDrawerScope.of(context);
    final isCollapsed = drawerScope?.isCollapsed ?? true;

    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0C0B162C),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  )
                ],
                gradient: !isCollapsed ? AppThemeImpl.getOptions(context).backgroundGradient(context) : null,
              ),
              child: Drawer(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SideBarHeader(),
                      Expanded(child: SideBarMenuWidget()),
                      const SizedBox(height: 24),
                      const SideBarFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CollapsedSidebar extends StatelessWidget {
  const CollapsedSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    List<AbstractRoute> routes = AppRouterScope.of(context).buildRoutes(context);
    List<AbstractRoute> active = routes.where((element) => element.active ?? true).toList();
    List<AbstractRoute> inactive = routes.where((element) => !(element.active ?? true)).toList();
    List allRoutes = [active, inactive];

    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous.fluxLogin != current.fluxLogin,
      builder: (BuildContext context, AuthState state) {
        PrivilegeLevel privilege = state.fluxLogin?.privilegeLevel ?? PrivilegeLevel.none;
        return Container(
          width: 64,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 23),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const SideBarButton(),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      final items = allRoutes[index];
                      return ListView(
                        shrinkWrap: true,
                        children: _buildCollapsedMenuItems(items, privilege),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: allRoutes.length),
              )
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildCollapsedMenuItems(List<AbstractRoute> items, PrivilegeLevel privilegeLevel) {
    List<Widget> menu = <Widget>[];
    for (AbstractRoute r in items) {
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
                collapsed: true,
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
            collapsed: true,
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
          collapsed: true,
          children: children,
        ),
      );
    } else if (r is ActionRoute) {
      if (r.privilege != null) {
        PrivilegeLevel currentLevel = privilege;
        for (var privilege in r.privilege!) {
          if (privilege == currentLevel) {
            menu.add(
              FunctionMenuItem(
                route: r,
                level: level,
                collapsed: true,
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
            collapsed: true,
          ),
        );
      }
    }
  }
}

class SideBarButton extends StatelessWidget {
  const SideBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appScope = AppDrawerScope.of(context);
    final isCollapsed = appScope?.isCollapsed ?? true;
    debugPrint('isCollapsed: $isCollapsed');
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () {
        if (isCollapsed) {
          appScope?.openDrawer();
        } else {
          appScope?.closeDrawer();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SvgPicture.asset(
          'assets/images/svg/sidebar_collapse_icon.svg',
          height: 10,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onBackground,
            BlendMode.srcIn,
          ),
        )
            .animate(target: isCollapsed ? 0 : 1)
            .swap(builder: (context, _) => const Icon(Icons.arrow_back))
            .rotate(begin: 0, end: 360),
      ),
    );
  }
}

class SideBarHeader extends StatelessWidget {
  const SideBarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfigScope.of(context)!;
    Widget? header = config.buildMenuHeader(context);
    return header ?? Container();
  }
}
