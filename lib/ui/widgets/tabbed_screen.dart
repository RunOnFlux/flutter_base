import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/blocs/base_repository.dart';
import 'package:flutter_base/extensions/history_extension.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/widgets/app_screen.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:flutter_base/utils/platform_info.dart';
import 'package:provider/provider.dart';

class TabSpec {
  IconData? icon;
  String title;
  String route;
  SimpleScreen child;

  TabSpec({this.icon, required this.route, required this.title, required this.child}) {
    child.stateInfo.route = route;
  }
}

class TabScreenPage {
  final int page;
  const TabScreenPage({required this.page});
}

abstract class TabbedScreen extends AppContentScreen {
  final TabScreenPage? initialPage;
  final double? tabsWidth;
  const TabbedScreen({super.key, this.initialPage, this.tabsWidth, required super.stateInfo});
}

class TabbedScreenState<T extends TabbedScreen> extends AppScreenState<T> with TickerProviderStateMixin, History {
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
      var baseRepository = context.read<BaseRepository>();
      baseRepository.screenInfo.value.currentState = tabs[tabController.index].child.stateInfo;
    });
    if (PlatformInfo().isWeb()) {
      tabController.addListener(() {
        updateBrowserURL(tabController.index);
      });
    }
  }

  void assignAppState(String route) {
    var baseRepository = context.read<BaseRepository>();
    var initialAppScreenInfo = baseRepository.appScreenRegistry.value.get(
      tabs[widget.initialPage != null ? widget.initialPage!.page : 0].route,
    );
    if (initialAppScreenInfo != null) {
      baseRepository.appScreenRegistry.value.set(widget.stateInfo.route, initialAppScreenInfo);

      Future.microtask(() {
        baseRepository.screenInfo.value.currentState = initialAppScreenInfo;
      });
    }
  }

  updateBrowserURL(int index) {
    replaceState(tabs[index].title, tabs[index].route);
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
              child: Column(
                children: [
                  Padding(padding: context.mainPadding(), child: titleHeader(context)),
                  TabBar(
                    // These are the widgets to put in each tab in the tab bar.
                    controller: tabController,
                    tabs: _buildTabs(),
                    isScrollable: MediaQuery.of(context).size.width < (widget.tabsWidth ?? 700),
                    labelColor: Theme.of(context).textTheme.titleLarge!.color,
                    overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                      if (states.contains(WidgetState.hovered)) {
                        return Theme.of(context).primaryColor.withValues(alpha: 0.5); //<-- SEE HERE
                      }
                      return null;
                    }),
                    onTap: (value) {
                      if (PlatformInfo().isWeb()) {
                        updateBrowserURL(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(controller: tabController, children: _buildChildren()),
    );
  }

  List<Tab> _buildTabs() {
    return tabs.map((e) {
      return Tab(
        icon: e.icon != null ? Icon(e.icon) : null,
        child: AutoSizeText(e.title, maxLines: 1, minFontSize: 6, style: Theme.of(context).textTheme.headlineSmall),
      );
    }).toList();
  }

  List<Widget> _buildChildren() {
    return tabs.map((e) => e.child).toList();
  }
}

abstract class TabContentScreen extends SimpleScreen {
  final TabbedScreenState parent;
  const TabContentScreen({super.key, required super.stateInfo, required this.parent});
}

abstract class TabContentScreenState<T extends TabContentScreen> extends SimpleScreenState<T>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.parent.assignAppState(widget.stateInfo.route);
  }
}

abstract class DeferredTabContentScreen extends SimpleScreen {
  final Function(String) assignAppState;
  const DeferredTabContentScreen({super.key, required super.stateInfo, required this.assignAppState});
}

abstract class DeferredTabContentScreenState<T extends DeferredTabContentScreen> extends SimpleScreenState<T>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.assignAppState(widget.stateInfo.route);
  }
}
