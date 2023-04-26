import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../routes/route.dart';
import '../app_screen.dart';
import '../scaffold/superscaffold.dart';
import '../titled_card.dart';
import 'menu_styles.dart';

const double kMenuItemHeight = 55.0;
const List<double> kMenuItemHeights = [55.0, 45, 35];

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
    final bool isSelected = widget.route.route == GoRouter.of(context).location;
    return SizedBox(
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
            color: Theme.of(context).primaryColor,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: EdgeInsets.only(left: isHovering ? 5 : 0),
              margin: EdgeInsets.only(left: isHovering ? 5 : 0, right: 0),
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor,
              child: ListTile(
                title: buildTitle(context, widget.route.title, widget.level, selected: isSelected),
                leading: buildIcon(context, widget.route.icon, selected: isSelected),
                trailing: widget.route.badge != null ? widget.route.badge!(context) : null,
                horizontalTitleGap: 0,
                onTap: () {
                  context.go(widget.route.route);
                  Future.microtask(() {
                    GetIt.I<ScreenInfo>().currentState = widget.route.body!.stateInfo;
                  });
                },
                visualDensity: VisualDensity(vertical: -(widget.level * 2.0)),
              ),
            ),
          ),
        ),
      ),
    );
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
                  buildIcon(context, widget.icon, selected: isHovering, size: kDrawerWidth / 8.5),
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
