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
    var c = [const Color(0xFF818795), const Color(0xFFD9D9D9)];
    if (Theme.of(context).brightness == Brightness.dark) {
      c = c.reversed.toList();
    }
    final unselectedColor = (widget.route.active ?? true) ? c[0] : c[1];
    Color selectedColor = Colors.white;

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
    );
  }
}
