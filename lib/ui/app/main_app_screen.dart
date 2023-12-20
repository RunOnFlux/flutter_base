import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/window.dart';
import 'package:flutter_acrylic/window_effect.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/theme/interface_brightness.dart';
import 'package:flutter_base/ui/widgets/floating_action_menu.dart';
import 'package:flutter_base/ui/widgets/navbar/navbar.dart';
import 'package:flutter_base/ui/widgets/popup_message.dart';
import 'package:flutter_base/ui/widgets/responsive_builder.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:flutter_base/utils/platform_info.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainAppScreen extends StatelessWidget {
  const MainAppScreen({
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

class AppScreenDelegate extends StatefulWidget with GetItStatefulWidgetMixin {
  AppScreenDelegate({
    super.key,
    required this.config,
  });

  final AppConfig config;

  @override
  State<AppScreenDelegate> createState() => AppScreenState();
}

class AppScreenState extends State<AppScreenDelegate> with AutomaticKeepAliveClientMixin, GetItStateMixin {
  /*@override
  void initState() {
    super.initState();

    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb && mounted) {
        FlutterWindowClose.setWebReturnValue(context.tr.exitApplicationPrompt);
      }
    });*/
  }*/

  WindowEffect effect =
      PlatformInfo().getCurrentPlatformType() == PlatformType.windows ? WindowEffect.aero : WindowEffect.acrylic;
  Color color = const Color(0xCC222222);
  InterfaceBrightness brightness = InterfaceBrightness.auto;

  @override
  void initState() {
    super.initState();
    if (!PlatformInfo().isWeb() && PlatformInfo().isDesktopOS()) {
      setWindowEffect(effect);
    }
  }

  void setWindowEffect(WindowEffect? value) {
    Window.setEffect(
      effect: value!,
      color: color,
      dark: brightness == InterfaceBrightness.dark,
    );
    if (!PlatformInfo().isWeb() && Platform.isMacOS) {
      if (brightness != InterfaceBrightness.auto) {
        Window.overrideMacOSBrightness(dark: brightness == InterfaceBrightness.dark);
      }
    }
    setState(() => effect = value);
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

  void closeDrawer([bool close = true]) {
    if (_isSmallScreen) {
      _scaffoldKey.currentState?.closeDrawer();
    } else {
      if (mounted && close) {
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
    var currentState = watchOnly((ScreenInfo info) => info.currentState);

    if (currentState == null) {
      // check the registry
      final currentRoute = GoRouterState.of(context).fullPath;
      if (currentRoute != null) {
        currentState = GetIt.I<AppScreenRegistry>().get(currentRoute);
      }
    }

    var sideBar = const NavBar().animate(target: _isCollapsed ? 1 : 0)
      ..fadeOut()
      ..slideX(
        begin: 0,
        end: -1,
      );
    final child = context.watch<StatefulNavigationShell>();
    return AppDrawerScope(
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
                title: AppConfigScope.of(context)?.buildAppBarTitle(context),
                actions: [
                  ...AppConfigScope.of(context)?.buildTitleActionButtons(context) ?? [],
                ],
              )
            : AppConfigScope.of(context)?.hasTitleBar ?? false
                ? AppBar(
                    centerTitle: false,
                    elevation: 0,
                    title: AppConfigScope.of(context)?.buildAppBarTitle(context),
                    actions: [
                      ...AppConfigScope.of(context)?.buildTitleActionButtons(context) ?? [],
                    ],
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
              child: _AppScreenChildWrapper(
                state: currentState,
                child: child,
              ),
            ),
          ],
        ),
        drawer: _isSmallScreen ? sideBar : null,
        floatingActionButton: (currentState?.fabIcon != null)
            ? FloatingActionMenu(
                icon: currentState?.fabIcon ?? Icons.refresh,
                onPressed: () {
                  if (currentState != null && currentState.onFAB != null) {
                    currentState.onFAB!();
                  }
                },
                items: currentState?.items,
              )
            : null,
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

class _AppScreenChildWrapper extends StatefulWidget with GetItStatefulWidgetMixin {
  _AppScreenChildWrapper({
    required this.child,
    required this.state,
  });
  final Widget child;
  final AppScreenStateInfo? state;

  @override
  State<_AppScreenChildWrapper> createState() => _AppScreenChildWrapperState();
}

class _AppScreenChildWrapperState extends State<_AppScreenChildWrapper> with GetItStateMixin {
  double _endValue = 1.0;

  Timer? _timer;
  double timerPosition = 0;
  double timerValue = 0;
  bool timerCountUp = true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        timerPosition += (timerCountUp ? 1 : -1);
        timerValue += 1;
      });
      if (timerValue >= widget.state!.refreshInterval!) {
        if (widget.state?.onRefresh != null) {
          widget.state?.onRefresh!();
        }
        setState(() {
          timerValue = 0;
          timerCountUp = !timerCountUp;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final smallScreen = context.isSmallWidth();
    final isCollapsed = AppDrawerScope.of(context)?.isCollapsed ?? true;

    registerHandler((ScreenInfo s) => s.state, (context, value, cancel) {
      if (value == null || value.refreshInterval == null) {
        _timer?.cancel();
        return;
      }
      if (value.refreshInterval != null && value.refreshInterval! > 0) {
        startTimer();
      }
    });

    final child = Stack(
      children: [
        DecoratedBox(
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
              child: widget.child,
            ),
          ),
        ),
        if (widget.state?.refreshInterval != null && widget.state!.refreshInterval! > 0)
          if (PlatformInfo().isWeb())
            LinearProgressIndicator(
              value: timerPosition / widget.state!.refreshInterval!,
              color: Theme.of(context).primaryColor,
              minHeight: 1,
            ),
        if (widget.state?.refreshInterval != null && widget.state!.refreshInterval! > 0)
          if (!PlatformInfo().isWeb())
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: _endValue),
              duration: Duration(seconds: widget.state!.refreshInterval!),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                color: Theme.of(context).primaryColor,
                minHeight: 1,
              ),
              onEnd: () {
                if (widget.state?.onRefresh != null) {
                  widget.state?.onRefresh!();
                }
                setState(() {
                  _endValue = _endValue == 1.0 ? 0 : 1.0;
                });
              },
            ),
      ],
    );
    if (smallScreen) {
      return child;
    }
    return child.animate(target: isCollapsed ? 0 : 1).scaleX(begin: 1, end: 0.97).scaleY(begin: 1, end: 0.97);
  }
}
