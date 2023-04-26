import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/widgets/app_screen.dart';
import 'package:flutter_base/utils/platform_info.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

class TabSpec {
  IconData? icon;
  String title;
  String? route;
  AppScreen child;

  TabSpec({
    this.icon,
    this.route,
    required this.title,
    required this.child,
  });
}

class TabScreenPage {
  int page;
  TabScreenPage({
    required this.page,
  });
}

abstract class TabbedScreen extends AppScreen {
  final TabScreenPage? initialPage;
  final double? tabsWidth;
  const TabbedScreen({
    super.key,
    this.initialPage,
    this.tabsWidth,
    super.stateInfo,
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
    Future.microtask(() {
      GetIt.I<ScreenInfo>().currentState = tabs[tabController.index].child.stateInfo;
    });
  }

  updateBrowserURL(int index) {
    if (tabs[index].route != null) {
      html.window.history.replaceState(null, tabs[index].title, tabs[index].route!);
      // Update the browser tab title
      context.read<WindowTitle>().setTitle(tabs[index].title);
    }
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
