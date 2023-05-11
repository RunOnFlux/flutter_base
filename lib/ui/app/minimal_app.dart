import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_base/ui/app/app_route.dart';
import 'package:flutter_base/ui/app/loading_notifier.dart';
import 'package:flutter_base/ui/app/menu_drawer.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/routes/routes.dart';
import 'package:flutter_base/ui/screens/loading_screen.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/theme/interface_brightness.dart';
import 'package:flutter_base/ui/widgets/app_screen.dart';
import 'package:flutter_base/ui/widgets/scaffold/scaffoldstate.dart';
import 'package:flutter_base/ui/widgets/scaffold/superappbar_widget.dart';
import 'package:flutter_base/ui/widgets/scaffold/superscaffold.dart';
import 'package:flutter_base/ui/widgets/snack.dart';
import 'package:flutter_base/ui/widgets/window_title_bar.dart';
import 'package:flutter_base/utils/platform_info.dart';
import 'package:flutter_base/utils/settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:go_router/go_router.dart';
import 'package:i18n_extension/i18n_widget.dart';
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
          debugPrint('${loading.loadingComplete}');
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
              debugPrint('Android - check initial route: ${widget.settings.getString(Setting.initialRoute.name)}');
              if (widget.settings.getString(Setting.initialRoute.name) != '/') {
                initialRoute = widget.settings.getString(Setting.initialRoute.name);
                widget.settings.setString(Setting.initialRoute.name, '/');
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

  Widget buildMainApp(BuildContext context) {
    if (!PlatformInfo().isWeb() && PlatformInfo().isDesktopOS()) {
      setWindowTitle(windowTitle);
    }
    NavigationRoute? initialNavRoute;
    router = GoRouter(
      initialLocation: initialRoute,
      routes: widget.router.getNavigationRoutes().map(
        (e) {
          if (e.route == initialRoute) {
            initialNavRoute = config.verifyInitialRoute(e);
          }
          return AppRoute(
            e.route,
            (GoRouterState state) => I18n(
              child: AppBody(
                route: e,
                router: widget.router,
                config: config,
              ),
            ),
          );
        },
      ).toList(),
    );
    if (initialNavRoute != null) {
      Future.microtask(() => GetIt.I<ScreenInfo>().currentState = initialNavRoute!.body!.stateInfo);
    }

    return Builder(
      builder: (themeContext) {
        return MaterialApp.router(
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          localizationsDelegates: config.localizationDelegates,
          supportedLocales: config.supportedLocales,
          debugShowCheckedModeBanner: false,
          title: windowTitle,
          theme: ThemeProvider.themeOf(themeContext).data,
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}

class AppBody extends StatefulWidget with GetItStatefulWidgetMixin {
  AppBody({
    Key? key,
    required this.route,
    required this.router,
    required this.config,
  }) : super(key: key);

  final NavigationRoute route;
  final AppRouter router;
  final AppConfig config;

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

class AppBodyState extends SuperState<AppBody> with GetItStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return (!PlatformInfo().isWeb() && PlatformInfo().isDesktopOS())
        ? TitlebarSafeArea(
            child: getContent(context),
          )
        : ChangeNotifierProvider<WindowTitle>(
            create: (_) => WindowTitle(title: widget.route.title),
            child: buildTitle(context),
          );
  }

  Widget buildTitle(BuildContext context) {
    return Consumer<WindowTitle>(builder: (_, title, __) {
      debugPrint('buildTitle: ${title.title}');
      return SafeArea(
        child: Title(
          color: Theme.of(context).primaryColor,
          title: widget.config.getWindowTitle(this, title),
          child: getContent(context),
        ),
      );
    });
  }

  double _endValue = 1.0;

  Widget getContent(BuildContext context) {
    return Stack(
      children: [
        widget.config.wrapScaffold(this, _buildScaffold(context), context),
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
  }

  Hero? buildAppBar(BuildContext context) {
    return widget.config.hasTitleBar
        ? Hero(
            tag: "appbar",
            child: SuperAppBar(
              centerTitle: false,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.config.buildTitleWidgets(this, context),
                ],
              ),
              actions: [
                ...widget.config.buildTitleActionButtons(this, context),
              ],
            ),
          )
        : null;
  }
}

class AppConfig {
  bool get hasTitleBar => true;

  String getWindowTitle(AppBodyState body, WindowTitle title) {
    return title.title;
  }

  List<Widget> buildTitleActionButtons(AppBodyState body, BuildContext context) {
    return [];
  }

  List<Widget> buildTitleWidgets(AppBodyState body, BuildContext context) {
    return [];
  }

  Widget? buildMenuHeader(AppBodyState body, BuildContext context) {
    return null;
  }

  Widget? buildMenuFooter(AppBodyState body, BuildContext context) {
    return null;
  }

  Widget wrapScaffold(AppBodyState body, SuperScaffold scaffold, BuildContext context) {
    return scaffold;
  }

  NavigationRoute verifyInitialRoute(NavigationRoute route) {
    return route;
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
