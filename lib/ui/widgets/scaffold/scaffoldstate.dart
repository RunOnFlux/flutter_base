import 'package:flutter/material.dart';

import 'superscaffold_controller.dart';

mixin SuperStateMixin {
  SuperScaffoldController? scaffold;
  TabController? tabController;

  int get tabsLength => 0;

  bool get hasTabs => tabsLength > 0;

  @protected
  void createTabControllerOfTickerProvider(TickerProvider vsync) {
    if (hasTabs) {
      tabController = TabController(length: tabsLength, vsync: vsync);
    }
  }
}

abstract class ISuperState<T extends StatefulWidget> extends State<T> with SuperStateMixin {
  @override
  void initState();
}

abstract class SuperState<T extends StatefulWidget> extends State<T>
    with SuperStateMixin, TickerProviderStateMixin
    implements ISuperState<T> {
  @override
  void initState() {
    super.initState();
    createTabControllerOfTickerProvider(this);
  }
}
