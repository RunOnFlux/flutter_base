import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_base/ui/app/app_route.dart';
import 'package:flutter_base/ui/app/loading_notifier.dart';
import 'package:flutter_base/ui/app/main_app_screen.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/routes/routes.dart';
import 'package:flutter_base/ui/screens/loading_screen.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/logo.dart';
import 'package:flutter_base/ui/widgets/navbar/navbar.dart';
import 'package:flutter_base/ui/widgets/responsive_builder.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:flutter_base/ui/widgets/snack.dart';
import 'package:flutter_base/utils/platform_info.dart';
import 'package:flutter_base/utils/settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:window_size/window_size.dart';

/*

  Some of you may not have seen a Flutter app before.
  - Safety Pig included to help you through the process...
                         _
 _._ _..._ .-',     _.._(`)) 
'-. `     '  /-._.-'    ',/
   )         \            '.
  / _    _    |             \
 |  a    a    /              |
 \   .-.                     ;
  '-('' ).-'       ,'       ;
     '-;           |      .'
        \           \    /
        | 7  .__  _.-\   \
        | |  |  ``/  /`  /
       /,_|  |   /,_/   /
          /,_/      '`-'

 */
abstract class MinimalApp extends StatefulWidget {
  final AppRouter router;
  final Settings settings;

  MinimalApp({
    required this.router,
    required this.settings,
    Key? key,
  }) : super(key: key) {
    GetIt.I.registerSingleton<ScreenInfo>(ScreenInfo());
    GetIt.I.registerSingleton<AppScreenRegistry>(AppScreenRegistry());
    registerTheme();
  }

  registerTheme() {
    GetIt.I.registerSingleton<AppThemeImpl>(AppThemeImpl());
  }
}

abstract class MinimalAppState<T extends MinimalApp> extends State<T> {
  // This widget is the root of your application.
  var initialRoute = '/';

  LoadingNotifier get loadingNotifier => LoadingNotifier();

  String get initialWindowTitle => 'FluxOS - checking access...';
  String get windowTitle => 'Window Title';

  AppTheme get light => GetIt.I<AppThemeImpl>().light;
  AppTheme get dark => GetIt.I<AppThemeImpl>().dark;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoadingNotifier>(
        create: (_) => loadingNotifier,
        builder: (context, _) {
          final loading = Provider.of<LoadingNotifier>(context);
          return ThemeProvider(
            defaultThemeId: widget.settings.getBool(Setting.darkMode.name, defaultValue: true) ? dark.id : light.id,
            themes: <AppTheme>[
              light,
              dark,
            ],
            child: ThemeConsumer(
              child: (loading.loadingComplete) ? buildMainApp(context) : buildLoadingApp(context),
            ),
          );
        });
  }

  Widget buildLoadingApp(BuildContext context) {
    final list = context.watch<LoadingNotifier>();
    if (list.isError) {
      Future.delayed(const Duration(seconds: 5), () => list.fetchData());
    }
    if (!PlatformInfo().isWeb() && PlatformInfo().isDesktopOS()) {
      setWindowTitle(initialWindowTitle);
    }
    return Builder(builder: (themeContext) {
      return MaterialApp(
        title: initialWindowTitle,
        theme: ThemeProvider.themeOf(themeContext).data,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name != null) {
            initialRoute = settings.name!;
            if (PlatformInfo().getCurrentPlatformType() == PlatformType.android) {
              var route = config.getInitialRoute(widget.settings);
              debugPrint('Android - check initial route: $route');
              if (route != '/') {
                initialRoute = route;
                config.setInitialRoute('/', widget.settings);
              }
            }
            return MaterialPageRoute(builder: (context) {
              return const LoadingScreen();
            });
          }
          return null;
        },
      );
    });
  }

  AppConfig get config;

  late GoRouter router;

  ValueNotifier<RoutingConfig> appRoutingConfig = ValueNotifier<RoutingConfig>(
    const RoutingConfig(
      routes: [],
    ),
  );

  RoutingConfig buildRoutingConfig() {
    var allRoutes = widget.router.getNavigationRoutes();
    return RoutingConfig(
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppRouterScope(
              router: widget.router,
              child: MainAppScreen(
                config: config,
                child: navigationShell,
              ),
            );
          },
          branches: allRoutes.map(
            (e) {
              return StatefulShellBranch(
                routes: [
                  AppRoute(
                    path: e.route,
                    builder: (GoRouterState state) => AppBody(route: e),
                  )
                ],
                initialLocation: e.initialLocation,
              );
            },
          ).toList(),
        ),
      ],
      redirect: (context, state) {
        Future.microtask(() {
          final currentRoute = state.fullPath?.toString() ?? '/'; // use fullPath to support routes with parameters
          GetIt.I<ScreenInfo>().currentState = GetIt.I<AppScreenRegistry>().get(currentRoute);
        });

        return null;
      },
    );
  }

  Widget buildMainApp(BuildContext context) {
    if (!PlatformInfo().isWeb() && PlatformInfo().isDesktopOS()) {
      setWindowTitle(windowTitle);
    }
    var allRoutes = widget.router.getNavigationRoutes();
    NavigationRoute? initialNavRoute = allRoutes.firstWhereOrNull(
      (element) => element.route == initialRoute,
    );

    router = GoRouter.routingConfig(
      initialLocation: initialRoute,
      routingConfig: appRoutingConfig,
    );

    if (initialNavRoute != null) {
      Future.microtask(() => GetIt.I<ScreenInfo>().currentState = initialNavRoute.body!.stateInfo);
    }

    return AppConfigScope(
      config: config,
      child: Builder(
        builder: (themeContext) {
          return MaterialApp.router(
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            localizationsDelegates: config.localizationDelegates,
            supportedLocales: config.supportedLocales,
            debugShowCheckedModeBanner: false,
            title: windowTitle,
            theme: ThemeProvider.themeOf(themeContext).data,
            builder: (context, child) {
              return ResponsiveBuilder(child: child!);
            },
            routerConfig: router,
          );
        },
      ),
    );
  }
}

class AppBody extends StatefulWidget with GetItStatefulWidgetMixin {
  AppBody({
    Key? key,
    required this.route,
  }) : super(key: key);

  final NavigationRoute route;

  @override
  State<AppBody> createState() => AppBodyState();
}

class WindowTitle with ChangeNotifier {
  String title;

  WindowTitle({required this.title});

  void setTitle(String t) {
    title = t;
    notifyListeners();
  }
}

class AppBodyState extends State<AppBody> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    return (!PlatformInfo().isWeb() && PlatformInfo().isDesktopOS())
        ? TitlebarSafeArea(
            child: widget.route.body!,
          )
        : ChangeNotifierProvider<WindowTitle>(
            create: (_) => WindowTitle(title: widget.route.title),
            child: buildTitle(context),
          );
  }

  Widget buildTitle(BuildContext context) {
    return Consumer<WindowTitle>(builder: (_, title, __) {
      return SafeArea(
        child: Title(
          color: Theme.of(context).primaryColor,
          title: AppConfigScope.of(context)?.getWindowTitle(this, title) ?? '',
          child: widget.route.body!,
        ),
      );
    });
  }

  //double _endValue = 1.0;

  /*Widget getContent(BuildContext context) {
    return Stack(
      children: [
        if (AppConfigScope.of(context) != null)
          AppConfigScope.of(context)!.wrapScaffold(this, _buildScaffold(context), context),
        (!PlatformInfo().isWeb() && PlatformInfo().isDesktopOS())
            ? WindowTitleBar(brightness: brightness)
            : Container(),
      ],
    );
  }

  SuperScaffold _buildScaffold(BuildContext context) {
    var currentState = watchOnly((ScreenInfo info) => info.currentState);
    return SuperScaffold(
      drawerEdgeDragWidth: 75,
      appBar: buildAppBar(context),
      drawer: SideMenuDrawer(
        router: widget.router,
        config: widget.config,
        body: this,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                if (widget.route.body != null) widget.route.body!,
              ],
            ),
            if (widget.route.body != null && currentState?.refreshEnabled != null && currentState!.refreshEnabled!)
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: _endValue),
                duration: Duration(seconds: currentState.refreshInterval ?? 30),
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  color: Theme.of(context).primaryColor,
                  minHeight: 1,
                ),
                onEnd: () {
                  //log('animated refresh now');
                  //widget.route.body!.onRefresh();
                  if (currentState.onRefresh != null) {
                    currentState.onRefresh!();
                  }
                  setState(() {
                    _endValue = _endValue == 1.0 ? 0 : 1.0;
                  });
                },
              ),
          ],
        ),
      ),
      floatingActionButton: currentState?.fabEnabled ?? false
          ? Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: FloatingActionButton(
                onPressed: currentState?.onFAB,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(currentState?.fabIcon ?? Icons.refresh),
              ),
            )
          : null,
    );
  }*/

  /*Hero? buildAppBar(BuildContext context) {
    return AppConfigScope.of(context)?.hasTitleBar ?? false
        ? Hero(
            tag: "appbar",
            child: AppBar(
              centerTitle: false,
              elevation: 0,
              title: AppConfigScope.of(context)?.buildAppBarTitle(context),
              actions: [
                ...AppConfigScope.of(context)?.buildTitleActionButtons(this, context) ?? [],
              ],
            ),
          )
        : null;
  }*/
}

class AppConfig {
  bool get hasTitleBar => false;

  bool get smallScreenScroll => true;

  String getInitialRoute(Settings settings) {
    return settings.getString(Setting.initialRoute.name);
  }

  setInitialRoute(String route, Settings settings) {
    settings.setString(Setting.initialRoute.name, route);
  }

  String getWindowTitle(AppBodyState body, WindowTitle title) {
    return title.title;
  }

  List<Widget> buildTitleActionButtons(BuildContext context) {
    return [];
  }

  /*List<Widget> buildTitleWidgets(AppBodyState body, BuildContext context) {
    return [];
  }*/

  Widget? buildAppBarTitle(BuildContext context) {
    return null;
  }

  Widget? buildMenuHeader(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Logo(clickRedirectHomePage: true),
              SideBarButton(),
            ],
          ),
        ),
        Divider(),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget? buildMenuFooter(BuildContext context) {
    return null;
  }

  Widget wrapScaffold(AppBodyState body, Scaffold scaffold, BuildContext context) {
    return scaffold;
  }

  List<LocalizationsDelegate> get localizationDelegates => const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

  Iterable<Locale> get supportedLocales => const [
        Locale('en', "US"),
      ];
}

class LoginState with ChangeNotifier {
  PrivilegeLevel _privilege = PrivilegeLevel.none;

  PrivilegeLevel get privilege => _privilege;

  set privilege(PrivilegeLevel p) {
    _privilege = p;
    notifyListeners();
  }
}

class AppConfigScope extends InheritedWidget {
  const AppConfigScope({
    Key? key,
    required Widget child,
    required this.config,
  }) : super(key: key, child: child);
  final AppConfig config;

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfigScope>()?.config;
  }

  @override
  bool updateShouldNotify(covariant AppConfigScope oldWidget) {
    return false;
  }
}

class AppRouterScope extends InheritedWidget {
  const AppRouterScope({
    Key? key,
    required Widget child,
    required this.router,
  }) : super(key: key, child: child);
  final AppRouter router;

  static AppRouter of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppRouterScope>()!.router;
  }

  @override
  bool updateShouldNotify(covariant AppRouterScope oldWidget) {
    return false;
  }
}
