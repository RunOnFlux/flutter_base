import 'package:flutter/material.dart';

import 'breadcrumb_item.dart';

class BreadCrumbTile extends StatefulWidget {
  final BreadCrumbItem breadCrumbItem;
  final bool underline;
  final double padding;

  const BreadCrumbTile({super.key, required this.breadCrumbItem, this.underline = false, this.padding = 2.0});

  @override
  State<BreadCrumbTile> createState() => _BreadCrumbTileState();
}

class _BreadCrumbTileState extends State<BreadCrumbTile> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.breadCrumbItem.margin,
      child: Material(
        color: widget.breadCrumbItem.isEnable ? widget.breadCrumbItem.color : widget.breadCrumbItem.disableColor,
        shape: RoundedRectangleBorder(
          borderRadius: widget.breadCrumbItem.borderRadius,
          side: widget.breadCrumbItem.border,
        ),
        child: MouseRegion(
          onEnter:
              (_) => setState(() {
                if (widget.underline) {
                  hover = true;
                }
              }),
          onExit:
              (_) => setState(() {
                hover = false;
              }),
          child: InkWell(
            onTapDown: widget.breadCrumbItem.onTap,
            splashColor: widget.breadCrumbItem.splashColor,
            borderRadius: widget.breadCrumbItem.borderRadius as BorderRadius?,
            child: Padding(
              padding: widget.breadCrumbItem.padding,
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  color:
                      widget.breadCrumbItem.isEnable
                          ? widget.breadCrumbItem.textColor
                          : widget.breadCrumbItem.disabledTextColor,
                ),
                child: widget.underline ? _underline(widget.breadCrumbItem.content) : widget.breadCrumbItem.content,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _underline(Widget child) {
    return Stack(
      children: [
        child,
        Positioned(
          left: widget.padding,
          right: 0,
          bottom: 0,
          height: 1,
          child: Container(
            color:
                hover
                    ? Theme.of(context).textTheme.headlineSmall!.color ?? Theme.of(context).primaryColor
                    : Colors.transparent,
          ),
        ),
      ],
    );
  }
}
