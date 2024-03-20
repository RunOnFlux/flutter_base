import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/blocs/loading_bloc.dart';
import 'package:flutter_base/ui/app/app_route.dart';
import 'package:flutter_base/ui/app/config/app_config.dart';
import 'package:flutter_base/ui/app/config/auth_config.dart';
import 'package:flutter_base/ui/app/main_app_screen.dart';
import 'package:flutter_base/ui/app/scope/app_config_scope.dart';
import 'package:flutter_base/ui/app/scope/app_router_scope.dart';
import 'package:flutter_base/ui/app/scope/auth_config_scope.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/routes/routes.dart';
import 'package:flutter_base/ui/screens/loading_screen.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/auth/auth_screen.dart';
import 'package:flutter_base/ui/widgets/banner.dart';
import 'package:flutter_base/ui/widgets/responsive_builder.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:flutter_base/utils/platform_info.dart';
import 'package:flutter_base/utils/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    super.key,
  }) {
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

  String get initialWindowTitle => 'FluxOS - checking access...';
  String get windowTitle => 'Window Title';

  AppTheme get light => GetIt.I<AppThemeImpl>().light;
  AppTheme get dark => GetIt.I<AppThemeImpl>().dark;

  @override
  Widget build(BuildContext context) {
    Widget child = MultiBlocProvider(
      providers: [
        BlocProvider<LoadingBloc>(
          create: createLoadingBloc,
        ),
        ...createRootBlocs(context),
        if (authConfig != null && authConfig!.firebaseOptions != null)
          BlocProvider<AuthBloc>(
              lazy: false,
              create: (context) {
                debugPrint('BlocProvider: AuthBloc');
                final bloc = AuthBloc(firebaseOptions: authConfig!.firebaseOptions!);
                bloc.add(const InitializeAuthEvent());
                return bloc;
              }),
      ],
      child: BlocBuilder<LoadingBloc, LoadingState>(
        builder: handleLoadingState,
      ),
    );
    var repos = createRootRepositories(context);
    // Can't use an empty list with MultiRepositoryProvider
    if (repos.isNotEmpty) {
      child = MultiRepositoryProvider(providers: repos, child: child);
    }
    return ThemeProvider(
      defaultThemeId: widget.settings.getBool(Setting.darkMode.name, defaultValue: true) ? dark.id : light.id,
      themes: <AppTheme>[
        light,
        dark,
      ],
      child: ThemeConsumer(child: authWrapper(child)),
    );
  }

  Widget authWrapper(Widget child) {
    if (authConfig != null) {
      return AuthConfigScope(config: authConfig!, child: child);
    }
    return child;
  }

  Widget handleLoadingState(BuildContext context, LoadingState state) {
    if (state is AppLoadedState) {
      return buildMainApp(context);
    } else {
      return buildLoadingApp(context);
    }
  }

  List<BlocProvider> createRootBlocs(BuildContext context) => [];
  List<RepositoryProvider> createRootRepositories(BuildContext context) => [];

  LoadingBloc createLoadingBloc(BuildContext context) {
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
  AuthConfig? get authConfig;

  late GoRouter router;

  ValueNotifier<RoutingConfig> appRoutingConfig = ValueNotifier<RoutingConfig>(
    const RoutingConfig(
      routes: [],
    ),
  );

  RoutingConfig buildRoutingConfig(BuildContext context) {
    var allRoutes = widget.router.getNavigationRoutes(context);
    return RoutingConfig(
      routes: [
        ShellRoute(
          navigatorKey: rootNavigatorKey,
          routes: [
            ShellRoute(
              parentNavigatorKey: rootNavigatorKey,
              navigatorKey: mainNavigatorKey,
              pageBuilder: (context, state, child) {
                return NoTransitionPage(child: child);
              },
              routes: [
                StatefulShellRoute.indexedStack(
                  parentNavigatorKey: mainNavigatorKey,
                  builder: (context, state, navigationShell) {
                    return AppRouterScope(
                      router: widget.router,
                      child: AuthChallengeWrapper(
                        child: MainAppScreen(
                          config: config,
                          child: navigationShell,
                        ),
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
            ),
            if (authConfig != null)
              ShellRoute(
                parentNavigatorKey: rootNavigatorKey,
                navigatorKey: authNavigatorKey,
                routes: [
                  GoRoute(
                    parentNavigatorKey: authNavigatorKey,
                    path: AuthFluxBranchRoute.rootPath,
                    redirect: (context, state) {
                      final currentURI = state.uri;
                      final queryParams = Map<String, String>.from(currentURI.queryParameters);
                      final modeFromQueryIfAny = queryParams['mode'] ?? 'login';
                      final redirectIfAny = queryParams['continueUrl'];
                      if (redirectIfAny != null) {
                        queryParams.remove('continueUrl');
                        queryParams['redirect'] = redirectIfAny;
                      }
                      queryParams.remove('mode');

                      final mode = AuthFluxBranchRoute.fromName(modeFromQueryIfAny) ?? AuthFluxBranchRoute.login;
                      final newUri = currentURI.replace(path: mode.fullPath, queryParameters: queryParams);

                      return newUri.toString();
                    },
                  ),
                  for (final route in AuthFluxBranchRoute.signInRoutes)
                    GoRoute(
                      path: route.fullPath,
                      parentNavigatorKey: authNavigatorKey,
                      pageBuilder: (context, state) {
                        final authBloc = context.read<AuthBloc>();
                        final builder = authConfig!.authPageBuilder(route);
                        final arg = route.getArg(authBloc.state, state);

                        return NoTransitionPage(
                          child: AuthScreen(child: builder(arg)),
                        );
                      },
                    ),
                  for (final route in AuthFluxBranchRoute.actionRoutes)
                    GoRoute(
                      parentNavigatorKey: authNavigatorKey,
                      path: route.fullPath,
                      pageBuilder: (context, state) {
                        final queryParams = Map<String, String>.from(state.uri.queryParameters);
                        String? redirect = queryParams['redirect'];

                        final authBloc = context.read<AuthBloc>();
                        final builder = authConfig!.authPageBuilder(route);
                        final arg = route.getArg(authBloc.state, state);

                        return NoTransitionPage(
                          child: AuthScreen(child: builder(arg)),
                        );
                      },
                    ),
                ],
                pageBuilder: (context, state, child) {
                  final queryParams = Map<String, String>.from(state.uri.queryParameters);
                  String? redirect = queryParams['redirect'];

                  return NoTransitionPage(
                    child: BlocListener<AuthBloc, AuthState>(
                      listenWhen: (previous, current) =>
                          (previous.signInByPhoneProcessStarted != current.signInByPhoneProcessStarted) ||
                          (previous.hasFirebaseUser != current.hasFirebaseUser),
                      listener: (BuildContext context, AuthState authState) {
                        Router.neglect(context, () {
                          if (authState.hasFirebaseUser) {
                            if (redirect != null) {
                              debugPrint('going with redirect');
                              context.go(redirect);
                            } else {
                              if (redirectToRootAfterLogin) {
                                debugPrint('going without redirect to /');
                                context.go('/');
                              }
                            }
                          } else if (authState.signInByPhoneProcessStarted) {
                            final currentUri = state.uri;
                            final newUri = currentUri.replace(path: AuthFluxBranchRoute.phoneVerification.fullPath);
                            context.go(newUri.toString());
                          }
                        });
                      },
                      child: child,
                    ),
                  );
                },
              ),
          ],
          pageBuilder: (context, state, child) {
            return NoTransitionPage(child: child);
          },
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

  FutureOr<AuthBloc?> authWaitForAuthBloc(BuildContext context) async {
    try {
      final authBloc = context.read<AuthBloc>();
      //_AuthBlocInitializerWidget.of(context)?.showProgress(true);
      await authBloc.ensureInitialized();
      return authBloc;
    } catch (e) {
      return null;
    }
  }

  bool get redirectToRootAfterLogin => true;

  Widget buildMainApp(BuildContext context) {
    if (!PlatformInfo().isWeb() && PlatformInfo().isDesktopOS()) {
      setWindowTitle(windowTitle);
    }
    var allRoutes = widget.router.getNavigationRoutes(context);
    NavigationRoute? initialNavRoute = allRoutes.firstWhereOrNull(
      (element) => element.route == initialRoute,
    );

    router = GoRouter.routingConfig(
      debugLogDiagnostics: true,
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
              return ResponsiveBuilder(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (child != null) child,
                    AppBanner(text: config.banner),
                  ],
                ),
              );
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
    super.key,
    required this.route,
  });

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

/*class LoginState with ChangeNotifier {
  PrivilegeLevel _privilege = PrivilegeLevel.none;

  PrivilegeLevel get privilege => _privilege;

  set privilege(PrivilegeLevel p) {
    _privilege = p;
    notifyListeners();
  }
}*/

GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
GlobalKey<NavigatorState> authNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'auth');
GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'main');

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
