import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/main_app_screen.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

import '../../routes/route.dart';
import 'menu_styles.dart';

const double kMenuItemHeight = 24.0;
const List<double> kMenuItemHeights = [41, 41, 41];

class NavigationMenuItem extends StatefulWidget {
  final AbstractRoute route;
  final int level;
  final bool collapsed;

  const NavigationMenuItem({
    Key? key,
    required this.route,
    required this.level,
    this.collapsed = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NavigationMenuItemState();
}

class _NavigationMenuItemState extends State<NavigationMenuItem> with MenuStyles {
  @override
  Widget build(BuildContext context) {
    final bool isSelected = isRouteSelected();
    var c = Theme.of(context).menuColors;
    if (Theme.of(context).brightness == Brightness.dark) {
      c = c.reversed.toList();
    }
    final unselectedColor = (widget.route.active ?? true) ? c[0] : c[1];
    Color selectedColor = Theme.of(context).primaryColor;

    if (widget.collapsed) {
      return IconButton(
        tooltip: widget.route.title,
        style: IconButton.styleFrom(
          backgroundColor: isSelected ? Theme.of(context).selectedMenuItem : Colors.transparent,
          shape: const CircleBorder(),
        ),
        isSelected: isSelected,
        onPressed: (widget.route.active ?? true)
            ? () {
                performAction();
              }
            : null,
        icon: buildIconWidget(
          widget.route,
          context,
          widget.level,
          isSelected,
          selectedColor,
          unselectedColor,
        ),
      );
    }

    var defaultIcon = buildIcon(
      context,
      Icons.chevron_right_outlined,
      selectedColor,
      unselectedColor,
      selected: isSelected,
      size: iconSizeForLevel(widget.level) * 1.2,
    );

    return Padding(
      padding: EdgeInsets.only(left: widget.level * 10),
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: kMenuItemHeights[widget.level],
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            selected: isSelected,
            dense: true,
            isThreeLine: false,
            titleTextStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: fontSizeForLevel(widget.level),
                ),
            titleAlignment: ListTileTitleAlignment.center,
            minVerticalPadding: 4,
            iconColor: unselectedColor,
            textColor: unselectedColor,
            selectedTileColor: Theme.of(context).selectedMenuItem,
            selectedColor: selectedColor,
            tileColor: Colors.transparent,
            title: buildTitle(
              context,
              widget.route.title,
              selectedColor,
              unselectedColor,
              widget.level,
              selected: isSelected,
            ),
            leading: buildIconWidget(
              widget.route,
              context,
              widget.level,
              isSelected,
              selectedColor,
              unselectedColor,
            ),
            trailing: widget.route.badge != null
                ? widget.route.badge!(
                    context,
                    defaultIcon,
                  )
                : defaultIcon,
            onTap: () {
              performAction();
            },
            enabled: widget.route.active ?? true,
          ),
        ),
      ),
    );
  }

  bool isRouteSelected() {
    return widget.route is NavigationRoute &&
        ((widget.route as NavigationRoute).route == GoRouterState.of(context).uri.toString());
  }

  performAction() {
    if (widget.route is NavigationRoute) {
      AppDrawerScope.of(context)?.closeDrawer(false);
      context.go((widget.route as NavigationRoute).route);
    }
  }
}

class FunctionMenuItem extends NavigationMenuItem {
  const FunctionMenuItem({
    super.key,
    required super.level,
    required super.route,
    super.collapsed = false,
  });

  @override
  State<StatefulWidget> createState() => _FunctionMenuItemState();
}

class _FunctionMenuItemState extends _NavigationMenuItemState {
  @override
  performAction() {
    if (widget.route is ActionRoute) {
      (widget.route as ActionRoute).action(context);
    } else {
      super.performAction();
    }
  }
}

/*class ActionMenuItem extends StatefulWidget {
  final Function() action;
  final String title;
  final IconData? icon;

  const ActionMenuItem({
    Key? key,
    required this.action,
    required this.title,
    this.icon,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ActionMenuItemState();
}

class _ActionMenuItemState extends State<ActionMenuItem> with MenuStyles {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
      child: SizedBox(
        width: 100,
        height: 100,
        child: GestureDetector(
          onTap: () {
            widget.action();
          },
          child: UntitledCard(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //buildIcon(context, widget.icon, selected: isHovering, size: kDrawerWidth / 8.5),
                  buildSmallTitle(context, widget.title, selected: isHovering),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
