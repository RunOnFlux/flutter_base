import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/main_app_screen.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:get_it/get_it.dart';
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
    final currentRoute = GoRouterState.of(context).uri.toString();
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
        menuChildren: List<MenuItemButton>.generate(
          widget.children.length,
          (int index) {
            var menuItem = widget.children[index] as NavigationMenuItem;
            var route = menuItem.route;
            bool isSelected = route.route == currentRoute;
            return MenuItemButton(
              child: SizedBox(
                width: 250,
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  selected: isSelected,
                  dense: true,
                  isThreeLine: false,
                  titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: fontSizeForLevel(menuItem.level),
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
                    menuItem.level,
                    selected: isSelected,
                  ),
                  leading: buildIconWidget(
                    route,
                    context,
                    menuItem.level,
                    isSelected,
                    selectedColor,
                    unselectedColor,
                  ),
                  trailing: route.badge != null
                      ? route.badge!(context)
                      : buildIcon(
                          context,
                          Icons.chevron_right_outlined,
                          selectedColor,
                          unselectedColor,
                        ),
                  onTap: () {
                    AppDrawerScope.of(context)?.closeDrawer(false);
                    context.go(route.route);
                    Future.microtask(() {
                      GetIt.I<ScreenInfo>().currentState = route.body!.stateInfo;
                    });
                  },
                  enabled: route.active ?? true,
                ),
              ),
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
}
