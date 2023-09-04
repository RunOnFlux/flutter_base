import 'package:flutter/material.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../routes/route.dart';
import '../scaffold/superscaffold.dart';
import '../titled_card.dart';
import 'menu_styles.dart';

const double kMenuItemHeight = 30.0;
const List<double> kMenuItemHeights = [47, 47, 47];

class NavigationMenuItem extends StatefulWidget {
  final NavigationRoute route;
  final int level;

  const NavigationMenuItem({
    Key? key,
    required this.route,
    required this.level,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NavigationMenuItemState();
}

class _NavigationMenuItemState extends State<NavigationMenuItem> with MenuStyles {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.route.route == GoRouterState.of(context).uri.toString();
    var c = [const Color(0xFF818795), const Color(0xFFD9D9D9)];
    if (Theme.of(context).brightness == Brightness.dark) {
      c = c.reversed.toList();
    }
    final unselectedColor = (widget.route.active ?? true) ? c[0] : c[1];
    Color selectedColor = Colors.white;

    return Padding(
      padding: EdgeInsets.only(left: widget.level * 20),
      child: SizedBox(
        height: kMenuItemHeights[widget.level],
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            //padding: EdgeInsets.only(left: isHovering ? 5 : 0),
            //margin: EdgeInsets.only(left: isHovering ? 5 : 0, right: 0),
            //color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              selected: isSelected,
              dense: true,
              isThreeLine: false,
              titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: fontSizeForLevel(widget.level),
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
                  ? widget.route.badge!(context)
                  : buildIcon(
                      context,
                      Icons.chevron_right_outlined,
                      selectedColor,
                      unselectedColor,
                    ),
              onTap: () {
                performAction();
              },
              enabled: widget.route.active ?? true,
            ),
          ),
        ),
      ),
    );
  }

  performAction() {
    context.go(widget.route.route);
    Future.microtask(() {
      GetIt.I<ScreenInfo>().currentState = widget.route.body!.stateInfo;
    });
  }
}

class FunctionMenuItem extends NavigationMenuItem {
  const FunctionMenuItem({super.key, required super.level, required super.route});

  @override
  State<StatefulWidget> createState() => _FunctionMenuItemState();
}

class _FunctionMenuItemState extends _NavigationMenuItemState {
  @override
  performAction() {
    if (widget.route is ActionRoute) {
      (widget.route as ActionRoute).action();
    } else {
      super.performAction();
    }
  }
}

class ActionMenuItem extends StatefulWidget {
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
        width: kDrawerWidth / 3,
        height: kDrawerWidth / 3,
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
