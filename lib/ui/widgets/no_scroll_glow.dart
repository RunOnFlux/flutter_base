import 'package:flutter/material.dart';

class NoScrollGlowWidget extends StatelessWidget {
  const NoScrollGlowWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const NoScrollGlowBehavior(),
      child: child,
    );
  }
}

class NoScrollGlowBehavior extends ScrollBehavior {
  const NoScrollGlowBehavior();

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class DisabledScrollBehavior extends ScrollBehavior {
  const DisabledScrollBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const NeverScrollableScrollPhysics();
  }
}

class DisabledScrollWidget extends StatelessWidget {
  const DisabledScrollWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: const DisabledScrollBehavior(), child: child);
  }
}
