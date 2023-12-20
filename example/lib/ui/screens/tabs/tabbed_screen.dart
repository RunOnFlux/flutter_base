import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:flutter_base/ui/widgets/tabbed_screen.dart';
import 'package:flutter_base_example/ui/screens/tabs/tab_one.dart';
import 'package:flutter_base_example/ui/screens/tabs/tab_three.dart';
import 'package:flutter_base_example/ui/screens/tabs/tab_two.dart';

class ExampleTabsScreen extends TabbedScreen {
  static const TabScreenPage one = TabScreenPage(page: 0);
  static const TabScreenPage two = TabScreenPage(page: 1);
  static const TabScreenPage three = TabScreenPage(page: 2);

  ExampleTabsScreen({Key? key, TabScreenPage? initialPage, required String route})
      : super(
          key: key,
          initialPage: initialPage,
          tabsWidth: 600,
          route: route,
          stateInfo: AppScreenStateInfo(),
        );

  @override
  State<ExampleTabsScreen> createState() => ExampleTabsScreenState();
}

class ExampleTabsScreenState extends TabbedScreenState<ExampleTabsScreen> {
  @override
  void initState() {
    bootstrapGridParameters(gutterSize: 0);
    tabs = <TabSpec>[
      TabSpec(
        title: 'One',
        child: TabOneScreen(route: '/tabs/1', parent: this),
        route: '/tabs/1',
      ),
      TabSpec(
        title: 'Two',
        child: TabTwoScreen(route: '/tabs/2', parent: this),
        route: '/tabs/2',
      ),
      TabSpec(
        title: 'Three',
        child: TabThreeScreen(route: '/tabs/3', parent: this),
        route: '/tabs/3',
      ),
    ];
    debugPrint('tabs: ${tabs.length}');
    super.initState();
  }
}
