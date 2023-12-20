import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

class FloatingActionMenu extends StatefulWidget {
  final List<FloatingMenuItem>? items;
  final IconData icon;
  final Function()? onPressed;

  const FloatingActionMenu({
    super.key,
    required this.icon,
    this.items,
    this.onPressed,
  });

  @override
  State<FloatingActionMenu> createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu> with SingleTickerProviderStateMixin {
  // For the FAB
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: widget.items == null
          ? FloatingActionButton(
              onPressed: widget.onPressed ?? () {},
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(widget.icon),
            )
          : FloatingActionBubble(
              items: widget.items!.map((e) => e.createBubble(context, _animationController)).toList(),
              onPress: () =>
                  _animationController.isCompleted ? _animationController.reverse() : _animationController.forward(),
              iconData: widget.icon,
              animation: _animation,
              backGroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor!,
              iconColor: Theme.of(context).floatingActionButtonTheme.foregroundColor!,
            ),
    );
  }
}

class FloatingMenuItem {
  String title;
  Color? iconColor;
  Color? bubbleColor;
  IconData icon;
  TextStyle? titleStyle;
  Function()? onPress;

  FloatingMenuItem({
    required this.title,
    required this.icon,
    this.iconColor,
    this.bubbleColor,
    this.titleStyle,
    this.onPress,
  });

  Bubble createBubble(BuildContext context, AnimationController animationController) {
    return Bubble(
      title: title,
      iconColor: iconColor ?? Theme.of(context).floatingActionButtonTheme.foregroundColor!,
      bubbleColor: bubbleColor ?? Theme.of(context).floatingActionButtonTheme.backgroundColor!,
      icon: icon,
      titleStyle: titleStyle ?? Theme.of(context).inputDecorationTheme.labelStyle!,
      onPress: () {
        animationController.reverse();
        if (onPress != null) onPress!();
      },
    );
  }
}
