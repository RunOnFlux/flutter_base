import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/navbar/navbar.dart';
import 'package:flutter_base/ui/widgets/popup_message.dart';
import 'package:flutter_base/ui/widgets/responsive_builder.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.child,
    required this.config,
    this.stateInfo,
  });
  final StatefulNavigationShell child;
  final AppScreenStateInfo? stateInfo;
  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return PopupMessageWidget(
      child: Provider.value(
        value: child,
        child: AppScreenDelegate(config: config),
      ),
    );
  }
}

class AppScreenDelegate extends StatefulWidget {
  const AppScreenDelegate({super.key, required this.config});

  final AppConfig config;

  @override
  State<AppScreenDelegate> createState() => AppScreenState();
}

class AppScreenState extends State<AppScreenDelegate> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb && mounted) {
        FlutterWindowClose.setWebReturnValue(context.tr.exitApplicationPrompt);
      }
    });*/
  }

  void openDrawer() {
    if (_isSmallScreen) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      if (mounted) {
        setState(() {
          _isCollapsed = false;
        });
      }
    }
  }

  bool get isSmallScreen => _isSmallScreen;

  bool get isCollapsed {
    if (_isSmallScreen) {
      return !(_scaffoldKey.currentState?.isDrawerOpen ?? false);
    } else {
      return _isCollapsed;
    }
  }

  void closeDrawer() {
    if (_isSmallScreen) {
      _scaffoldKey.currentState?.closeDrawer();
    } else {
      if (mounted) {
        setState(() {
          _isCollapsed = true;
        });
      }
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isCollapsed = false;

  bool _isSmallScreen = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _isSmallScreen = context.isSmallWidth();

    var sideBar = const NavBar().animate(target: _isCollapsed ? 1 : 0).fadeOut().slideX(
          begin: 0,
          end: -1,
        );
    final child = context.watch<StatefulNavigationShell>();
    return AppConfigScope(
      config: widget.config,
      child: AppDrawerScope(
        state: this,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            drawerScrimColor: _isSmallScreen ? Colors.black54 : null,
            key: _scaffoldKey,
            appBar: _isSmallScreen
                ? AppBar(
                    elevation: 0,
                    centerTitle: false,
                    // ignore: prefer_const_constructors
                    leading: SideBarButton(),
                    title: widget.config.buildAppBarTitle(context),
                  )
                : null,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_isSmallScreen)
                  sideBar
                    ..swap(
                      builder: (context, child) => CollapsedSidebar(),
                    ),
                Expanded(
                  child: _AppScreenChildWrapper(child: child),
                ),
              ],
            ),
            drawer: _isSmallScreen ? sideBar : null),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AppDrawerScope extends InheritedWidget {
  const AppDrawerScope({Key? key, required Widget child, required this.state}) : super(key: key, child: child);
  final AppScreenState state;

  static AppScreenState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppDrawerScope>()?.state;
  }

  @override
  bool updateShouldNotify(AppDrawerScope oldWidget) {
    return state.isCollapsed != oldWidget.state.isCollapsed;
  }
}

class _AppScreenChildWrapper extends StatelessWidget {
  const _AppScreenChildWrapper({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final smallScreen = context.isSmallWidth();
    final isCollapsed = AppDrawerScope.of(context)?.isCollapsed ?? true;
    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignOutside,
          color: Theme.of(context).borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(smallScreen ? 0 : 25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.001),
        child: ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(smallScreen ? 0 : 25),
          child: this.child,
        ),
      ),
    );
    if (smallScreen) {
      return child;
    }
    return child.animate(target: isCollapsed ? 0 : 1).scaleX(begin: 1, end: 0.95).scaleY(begin: 1, end: 0.94);
  }
}
