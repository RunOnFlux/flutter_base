import 'package:flutter/material.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/ui/app/scope/app_router_scope.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/no_scroll_glow.dart';
import 'package:flutter_base/ui/widgets/sidemenu/menu_category.dart';
import 'package:flutter_base/ui/widgets/sidemenu/menu_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SideBarMenuWidget extends StatefulWidget {
  const SideBarMenuWidget({super.key});

  @override
  State<SideBarMenuWidget> createState() => _SideBarMenuWidgetState();
}

class _SideBarMenuWidgetState extends State<SideBarMenuWidget> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// To rebuild on page change
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous.fluxLogin != current.fluxLogin,
      builder: (BuildContext context, state) {
        PrivilegeLevel? privilege = state.fluxLogin?.privilegeLevel;
        final items = _buildMenu(context, privilege ?? PrivilegeLevel.none);
        return NoScrollGlowWidget(
          child: ScrollbarTheme(
            data: Theme.of(context).scrollbarTheme.copyWith(
                  thickness: const MaterialStatePropertyAll(4),
                  trackColor: const MaterialStatePropertyAll(Colors.transparent),
                  minThumbLength: 2,
                ),
            child: Builder(
              builder: (context) {
                return Scrollbar(
                  controller: _controller,
                  thumbVisibility: true,
                  interactive: true,
                  trackVisibility: false,
                  child: ListView(
                    controller: _controller,
                    padding: const EdgeInsets.only(bottom: 10),
                    shrinkWrap: true,
                    children: items,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /*List<Widget> _default(BuildContext context) {
    final items = AppRouterScope.of(context).buildRoutes();
    //final state = context.watch<StatefulNavigationShell>();
    final currentRoutendex = GoRouterState.of(context).uri.toString();
    return items.map((e) {
      final active = currentRoute == e.;
      return SideBarMenuItem(
          title: e.tr(context),
          iconAsset: e.iconAsset,
          onTap: defaultMenuIconTap,
          index: e.index,
          enabled: e.active,
          selected: active);
    }).toList();
  }*/

  List<Widget> _buildMenu(BuildContext context, PrivilegeLevel privilegeLevel) {
    List<AbstractRoute> routes = AppRouterScope.of(context).buildRoutes(context);
    List<AbstractRoute> enabledRoutes = routes.where((element) => element.active ?? true).toList();
    List<AbstractRoute> disabledRoutes = routes.where((element) => !(element.active ?? true)).toList();
    List<Widget> menu = <Widget>[];
    for (AbstractRoute r in enabledRoutes) {
      _buildMenuForRoute(r, menu, 0, privilegeLevel);
    }
    for (AbstractRoute r in disabledRoutes) {
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
            if (r.above != null) menu.add(r.above!);
            menu.add(
              NavigationMenuItem(
                route: r,
                level: level,
              ),
            );
            if (r.below != null) menu.add(r.below!);
            continue;
          }
        }
      } else {
        if (r.above != null) menu.add(r.above!);
        menu.add(
          NavigationMenuItem(
            route: r,
            level: level,
          ),
        );
        if (r.below != null) menu.add(r.below!);
      }
    } else if (r is RouteSet) {
      List<Widget> children = <Widget>[];
      for (AbstractRoute rr in r.routes) {
        _buildMenuForRoute(rr, children, level + 1, privilege);
      }
      if (r.above != null) menu.add(r.above!);
      menu.add(
        SideMenuCategory(
          route: r,
          level: level,
          children: children,
        ),
      );
      if (r.below != null) menu.add(r.below!);
    } else if (r is ActionRoute) {
      if (r.privilege != null) {
        PrivilegeLevel currentLevel = privilege;
        for (var privilege in r.privilege!) {
          if (privilege == currentLevel) {
            if (r.above != null) menu.add(r.above!);
            menu.add(
              FunctionMenuItem(
                route: r,
                level: level,
              ),
            );
            if (r.below != null) menu.add(r.below!);
            continue;
          }
        }
      } else {
        if (r.above != null) menu.add(r.above!);
        menu.add(
          FunctionMenuItem(
            route: r,
            level: level,
          ),
        );
        if (r.below != null) menu.add(r.below!);
      }
    }
  }
}

/*void defaultMenuIconTap(int index, BuildContext context) {
  final state = context.read<StatefulNavigationShell>();
  final currentIndex = state.currentIndex;

  final active = currentIndex == index;

  //if (kAutoCloseDrawerOnNavigation) {
  //  AppDrawerScope.of(context)?.closeDrawer();
  //}

  state.goBranch(index, initialLocation: active);
}*/

/// if no title is provided, use an icon button
class SideBarMenuItem {
  const SideBarMenuItem(
      {this.title,
      required this.iconAsset,
      required this.onTap,
      required this.index,
      this.enabled = false,
      this.selected = false});
  final String? title;
  final String iconAsset;
  final bool enabled;
  final int index;
  final bool selected;
  final void Function(int index, BuildContext context) onTap;

  Widget build(BuildContext context) {
    final th = Theme.of(context);
    var c = [const Color(0xFF818795), const Color(0xFFD9D9D9)];
    if (th.isDark) {
      c = c.reversed.toList();
    }
    final unselectedColor = enabled ? c[0] : c[1];
    Color selectedColor = title == null ? th.primaryColor : Colors.white;
    final SvgPicture icon = SvgPicture.asset(
      iconAsset,
      width: 24,
      colorFilter: ColorFilter.mode(selected ? selectedColor : unselectedColor, BlendMode.srcIn),
    );

    if (title == null) {
      return IconButton(
          style: const ButtonStyle(shape: MaterialStatePropertyAll(CircleBorder())),
          onPressed: () {
            if (enabled) {
              onTap(index, context);
            }
          },
          icon: icon);
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: enabled ? 2 : 0),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          selected: selected,
          dense: true,
          isThreeLine: false,
          onTap: () => onTap(index, context),
          titleTextStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: 1),
          minVerticalPadding: 16,
          iconColor: unselectedColor,
          textColor: unselectedColor,
          selectedTileColor: th.primaryColor,
          selectedColor: selectedColor,
          tileColor: Colors.transparent,
          trailing: SvgPicture.asset('assets/images/svg/chevron_right.svg',
              colorFilter: ColorFilter.mode(selected ? selectedColor : unselectedColor, BlendMode.srcIn)),
          leading: icon,
          title: Text(title!),
          enabled: enabled,
        ),
      ),
    );
  }
}
