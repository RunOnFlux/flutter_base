import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_base/blocs/loading_bloc.dart';
import 'package:flutter_base/ui/app/app_route.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
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

  //LoadingNotifier get loadingNotifier => LoadingNotifier();

  String get initialWindowTitle => 'FluxOS - checking access...';
  String get windowTitle => 'Window Title';

  AppTheme get light => GetIt.I<AppThemeImpl>().light;
  AppTheme get dark => GetIt.I<AppThemeImpl>().dark;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      defaultThemeId: widget.settings.getBool(Setting.darkMode.name, defaultValue: true) ? dark.id : light.id,
      themes: <AppTheme>[
        light,
        dark,
      ],
      child: ThemeConsumer(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LoadingBloc>(
              create: createLoadingBloc,
            ),
            ...createRootBlocs(context),
          ],
          child: BlocBuilder<LoadingBloc, LoadingState>(
            builder: handleLoadingState,
          ),
        ),
      ),
    );
  }

  Widget handleLoadingState(BuildContext context, LoadingState state) {
    if (state is AppLoadedState) {
      return buildMainApp(context);
    } else {
      return buildLoadingApp(context);
    }
  }

  List<BlocProvider> createRootBlocs(BuildContext context) => [];

  LoadingBloc createLoadingBloc(_) {
    final bloc = LoadingBloc();
    bloc.add(StartLoadingApp());
    return bloc;
  }

  Widget buildLoadingApp(BuildContext context) {
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
            return MaterialPageRoute(builder: createLoadingScreen);
          }
          return null;
        },
      );
    });
  }

  Widget createLoadingScreen(BuildContext context) {
    return const LoadingScreen();
  }

  AppConfig get config;

  late GoRouter router;

  ValueNotifier<RoutingConfig> appRoutingConfig = ValueNotifier<RoutingConfig>(
    const RoutingConfig(
      routes: [],
    ),
  );

  RoutingConfig buildRoutingConfig() {
    var allRoutes = widget.router.getNavigationRoutes(context);
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
    var allRoutes = widget.router.getNavigationRoutes(context);
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

class AppBody extends StatefulWidget {
  const AppBody({
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

class AppBodyState extends State<AppBody> {
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
