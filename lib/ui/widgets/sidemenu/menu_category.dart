import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/main_app_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/store.dart';
import '../../routes/route.dart';
import 'menu_item.dart';
import 'menu_styles.dart';

class SideMenuCategory extends StatefulWidget {
  final RouteSet route;
  final int level;
  final List<Widget> children;
  final bool collapsed;

  const SideMenuCategory({
    Key? key,
    required this.route,
    required this.level,
    required this.children,
    this.collapsed = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SideMenuCategoryState();
}

class _SideMenuCategoryState extends State<SideMenuCategory> with MenuStyles {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    var c = [const Color(0xFF818795), const Color(0xFFD9D9D9)];
    if (Theme.of(context).brightness == Brightness.dark) {
      c = c.reversed.toList();
    }
    final unselectedColor = (widget.route.active ?? true) ? c[0] : c[1];
    Color selectedColor = Colors.white;

    if (widget.collapsed) {
      return MenuAnchor(
        builder: (BuildContext context, MenuController controller, Widget? child) {
          return IconButton(
            tooltip: widget.route.title,
            style: IconButton.styleFrom(
              backgroundColor: Colors.transparent, //isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              shape: const CircleBorder(),
            ),
            onPressed: (widget.route.active ?? true)
                ? () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  }
                : null,
            icon: buildIconWidget(
              widget.route,
              context,
              widget.level,
              false,
              selectedColor,
              unselectedColor,
            ),
          );
        },
        anchorTapClosesMenu: false,
        style: MenuStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
            Colors.black.withAlpha(192),
          ),
          padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.zero,
          ),
        ),
        menuChildren: List<Widget>.generate(
          widget.children.length,
          (int index) {
            return buildMenu(
              child: widget.children[index],
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
              onTap: (AbstractRoute route) {
                if (route is ActionRoute) {
                  route.action(context);
                } else if (route is NavigationRoute) {
                  AppDrawerScope.of(context)?.closeDrawer(false);
                  context.go(route.route);
                }
              },
            );
          },
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: widget.level * 16.0),
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovering = true;
          });
        },
        onExit: (_) {
          setState(() {
            isHovering = false;
          });
        },
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          color: Colors.transparent,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: Store().get(widget.route.title) ?? false,
              title: SizedBox(
                height: kMenuItemHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: buildTitle(context, widget.route.title, selectedColor, unselectedColor, widget.level),
                ),
              ),

              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.only(
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  //padding: EdgeInsets.only(left: isHovering ? 5 : 0),
                  child: buildIconWidget(
                    widget.route,
                    context,
                    widget.level,
                    false,
                    selectedColor,
                    unselectedColor,
                  ),
                ),
              ),
              //tilePadding: const EdgeInsets.only(left: 0, right: 0),
              children: widget.children,
              onExpansionChanged: (expanded) {
                Store().put(widget.route.title, expanded);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenu({
    required Widget child,
    required Color selectedColor,
    required Color unselectedColor,
    required Null Function(AbstractRoute)? onTap,
  }) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    if (child is NavigationMenuItem) {
      var menuItem = child;
      var route = menuItem.route;
      bool isSelected = route.route == currentRoute;
      return buildMenuItem(
        isSelected: isSelected,
        level: menuItem.level,
        selectedColor: selectedColor,
        unselectedColor: unselectedColor,
        route: route,
        onTap: onTap,
      );
    } else if (child is SideMenuCategory) {
      var menuItem = child;
      return SubmenuButton(
        menuChildren: menuItem.children.map((e) {
          return buildMenu(
            child: e,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: onTap,
          );
        }).toList(),
        child: buildMenuContent(
          isSelected: false,
          level: menuItem.level,
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
          route: menuItem.route,
          onTap: null,
          isSubMenu: true,
        ),
      );
    } else {
      return const Text('Configuration Error');
    }
  }

  Widget buildMenuItem({
    required bool isSelected,
    required int level,
    required Color selectedColor,
    required Color unselectedColor,
    required NavigationRoute route,
    required Null Function(AbstractRoute)? onTap,
  }) {
    return MenuItemButton(
      child: buildMenuContent(
        isSelected: isSelected,
        level: level,
        selectedColor: selectedColor,
        unselectedColor: unselectedColor,
        route: route,
        onTap: onTap,
        isSubMenu: false,
      ),
    );
  }

  Widget buildMenuContent({
    required bool isSelected,
    required int level,
    required Color selectedColor,
    required Color unselectedColor,
    required AbstractRoute route,
    required Null Function(AbstractRoute)? onTap,
    required bool isSubMenu,
  }) {
    return SizedBox(
      width: 250,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        selected: isSelected,
        dense: true,
        isThreeLine: false,
        titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: fontSizeForLevel(level),
              letterSpacing: 1,
            ),
        minVerticalPadding: 16,
        iconColor: unselectedColor,
        textColor: unselectedColor,
        selectedTileColor: Theme.of(context).primaryColor,
        selectedColor: selectedColor,
        tileColor: Colors.transparent,
        title: buildTitle(
          context,
          route.title,
          selectedColor,
          unselectedColor,
          level,
          selected: isSelected,
        ),
        leading: buildIconWidget(
          route,
          context,
          level,
          isSelected,
          selectedColor,
          unselectedColor,
        ),
        trailing: route is NavigationRoute && route.badge != null
            ? route.badge!(context)
            : !isSubMenu
                ? buildIcon(
                    context,
                    Icons.chevron_right_outlined,
                    selectedColor,
                    unselectedColor,
                  )
                : null,
        onTap: onTap == null
            ? null
            : () {
                onTap(route);
              },
        enabled: route.active ?? true,
      ),
    );
  }
}
