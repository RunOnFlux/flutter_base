import 'package:flutter/material.dart';

import '../../../utils/store.dart';
import '../../routes/route.dart';
import 'menu_item.dart';
import 'menu_styles.dart';

class SideMenuCategory extends StatefulWidget {
  final RouteSet route;
  final int level;
  final List<Widget> children;

  const SideMenuCategory({
    Key? key,
    required this.route,
    required this.level,
    required this.children,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SideMenuCategoryState();
}

class _SideMenuCategoryState extends State<SideMenuCategory> with MenuStyles {
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
      child: ExpansionTile(
        initiallyExpanded: Store().get(widget.route.title) ?? false,
        title: SizedBox(
          height: kMenuItemHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: buildTitle(context, widget.route.title, widget.level),
          ),
        ),
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 6.0,
            top: 5.0,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: EdgeInsets.only(left: isHovering ? 5 : 0),
            child: widget.route.image != null
                ? buildImage(context, widget.route.image)
                : buildIcon(context, widget.route.icon),
          ),
        ),
        tilePadding: const EdgeInsets.only(left: 0, right: 0),
        children: widget.children,
        onExpansionChanged: (expanded) {
          Store().put(widget.route.title, expanded);
        },
      ),
    );
  }
}
