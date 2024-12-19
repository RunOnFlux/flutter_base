import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCase extends StatelessWidget {
  final Widget child;
  final double blur;
  final int? autoPlayDelay;
  const ShowCase({
    super.key,
    required this.child,
    this.blur = 2.0,
    this.autoPlayDelay,
  });

  @override
  Widget build(BuildContext context) {
    return ShowCaseScope(
      showcase: this,
      child: ShowCaseWidget(
        blurValue: blur,
        enableAutoScroll: true,
        autoPlay: autoPlayDelay != null,
        autoPlayDelay: Duration(milliseconds: autoPlayDelay ?? 4000),
        builder: (BuildContext context) {
          return child;
        },
      ),
    );
  }

  void startShowcase(BuildContext context, List<GlobalKey> keys) {
    log('start a showcase');
    ShowCaseWidget.of(context).startShowCase(keys);
  }
}

class ShowCaseScope extends InheritedWidget {
  const ShowCaseScope({
    super.key,
    required super.child,
    required this.showcase,
  });
  final ShowCase showcase;

  static ShowCase? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShowCaseScope>()?.showcase;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
