import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/widgets/app_screen.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:flutter_base/utils/platform_info.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class TabSpec {
  IconData? icon;
  String title;
  String route;
  TabContentScreen child;

  TabSpec({
    this.icon,
    required this.route,
    required this.title,
    required this.child,
  }) {
    child.stateInfo.route = route;
  }
}

class TabScreenPage {
  final int page;
  const TabScreenPage({
    required this.page,
  });
}

abstract class TabbedScreen extends AppContentScreen {
  final TabScreenPage? initialPage;
  final double? tabsWidth;
  const TabbedScreen({
    super.key,
    this.initialPage,
    this.tabsWidth,
    required super.stateInfo,
  });
}

class TabbedScreenState<T extends TabbedScreen> extends AppScreenState<T> with TickerProviderStateMixin {
  late TabController tabController;
  late List<TabSpec> tabs;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: widget.initialPage != null ? widget.initialPage!.page : 0,
    );
    tabController.addListener(() {
      GetIt.I<ScreenInfo>().currentState = tabs[tabController.index].child.stateInfo;
    });
    if (PlatformInfo().isWeb()) {
      tabController.addListener(() {
        updateBrowserURL(tabController.index);
      });
    }
  }

  void assignAppState(String route) {
    var initialAppScreenInfo =
        GetIt.I<AppScreenRegistry>().get(tabs[widget.initialPage != null ? widget.initialPage!.page : 0].route);
    if (initialAppScreenInfo != null) {
      GetIt.I<AppScreenRegistry>().set(widget.stateInfo.route, initialAppScreenInfo);

      Future.microtask(() {
        GetIt.I<ScreenInfo>().currentState = initialAppScreenInfo;
      });
    }
  }

  updateBrowserURL(int index) {
    html.window.history.replaceState(null, tabs[index].title, tabs[index].route);
    // Update the browser tab title
    context.read<WindowTitle>().setTitle(tabs[index].title);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            // This widget takes the overlapping behavior of the SliverAppBar,
            // and redirects it to the SliverOverlapInjector below. If it is
            // missing, then it is possible for the nested "inner" scroll view
            // below to end up under the SliverAppBar even when the inner
            // scroll view thinks it has not been scrolled.
            // This is not necessary if the "headerSliverBuilder" only builds
            // widgets that do not overlap the next sliver.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverToBoxAdapter(
              child: TabBar(
                // These are the widgets to put in each tab in the tab bar.
                controller: tabController,
                tabs: _buildTabs(),
                isScrollable: MediaQuery.of(context).size.width < (widget.tabsWidth ?? 700),
                labelColor: Theme.of(context).textTheme.titleLarge!.color,
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Theme.of(context).primaryColor.withOpacity(0.5); //<-- SEE HERE
                    }
                    return null;
                  },
                ),
                onTap: (value) {
                  if (PlatformInfo().isWeb()) {
                    updateBrowserURL(value);
                  }
                },
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: tabController,
        children: _buildChildren(),
      ),
    );
  }

  List<Tab> _buildTabs() {
    return tabs.map((e) {
      return Tab(
        icon: e.icon != null ? Icon(e.icon) : null,
        child: AutoSizeText(
          e.title,
          maxLines: 1,
          minFontSize: 6,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    }).toList();
  }

  List<Widget> _buildChildren() {
    return tabs.map((e) => e.child).toList();
  }
}

abstract class TabContentScreen extends SimpleScreen {
  final TabbedScreenState parent;
  const TabContentScreen({
    super.key,
    required super.stateInfo,
    required this.parent,
  });
}

abstract class TabContentScreenState<T extends TabContentScreen> extends SimpleScreenState<T>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.parent.assignAppState(widget.stateInfo.route);
  }
}
