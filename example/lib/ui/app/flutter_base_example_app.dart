import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/blocs/loading_bloc.dart';
import 'package:flutter_base/ui/app/config/app_config.dart';
import 'package:flutter_base/ui/app/config/auth_config.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/theme/colors.dart';
import 'package:flutter_base/ui/widgets/gradients/gradient_divider.dart';
import 'package:flutter_base/ui/widgets/gradients/gradient_text.dart';
import 'package:flutter_base/ui/widgets/logo.dart';
import 'package:flutter_base/ui/widgets/navbar/navbar.dart';
import 'package:flutter_base_example/config/constants.dart';
import 'package:flutter_base_example/config/firebase_configs/firebase_options.dart';
import 'package:flutter_base_example/ui/app/showcase.dart';
import 'package:flutter_base_example/ui/routes/routes.dart';
import 'package:flutter_base_example/ui/widgets/footer.dart';
import 'package:flutter_base_example/utils/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:showcaseview/showcaseview.dart';

import 'loading.dart';

class FlutterBaseExampleApp extends MinimalApp {
  FlutterBaseExampleApp({Key? key}) : super(key: key, router: ExampleAppRouter(), settings: ExampleSettings());

  @override
  State<FlutterBaseExampleApp> createState() => _FlutterBaseExampleAppState();
}

class _FlutterBaseExampleAppState extends MinimalAppState<FlutterBaseExampleApp> with WidgetsBindingObserver {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  String get initialWindowTitle => 'Example App';
  @override
  String get windowTitle => 'Example App';
  //@override
  //ExampleLoadingNotifier get loadingNotifier => ExampleLoadingNotifier();

  @override
  Widget buildMainApp(BuildContext context) {
    //GetIt.I<NodeCollaterals>().collaterals = loadingNotifier.collaterals;
    appRoutingConfig.value = buildRoutingConfig(context);

    Future.microtask(() async {
      if (context.mounted) {
        widget.router.buildRoutes(context);
        appRoutingConfig.value = buildRoutingConfig(context);
      }
    });

    Widget mainApp = super.buildMainApp(context);

    //NotificationService().setupFlutterNotifications();
    //NotificationService().router = router;

    return mainApp;
    //return mainApp;
  }

  @override
  Widget handleLoadingState(BuildContext context, LoadingState state) {
    debugPrint('handle loading state');
    debugPrint(state.toString());
    if (state is TrendingAppsLoadedState) {
      debugPrint('trending apps loaded');
    }
    return super.handleLoadingState(context, state);
  }

  @override
  AppConfig get config => FlutterBaseAppConfig();
  @override
  AuthConfig? get authConfig => FlutterBaseAuthConfig();

  @override
  MyLoadingBloc createLoadingBloc(_) {
    final bloc = MyLoadingBloc();
    bloc.add(StartLoadingApp());
    return bloc;
  }

  @override
  Widget createLoadingScreen(BuildContext context) {
    return const MyLoadingScreen();
  }
}

class MyLoadingScreen extends StatelessWidget {
  const MyLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppThemeImpl.getOptions(context).appBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 100,
              height: 100,
              child: LoadingIndicator(indicatorType: Indicator.lineScale, colors: kDefaultRainbowColors),
            ),
            BlocBuilder<LoadingBloc, LoadingState>(
              builder: (context, state) {
                if (state is AppLoadProgressState) {
                  return Text(state.message);
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FlutterBaseAppConfig extends AppConfig {
  @override
  String? get banner => 'YES!';

  @override
  bool get smallScreenScroll => false;

  @override
  double get showcaseBlur => 8.0;

  @override
  String getWindowTitle(AppBodyState body, WindowTitle title) {
    return 'Example App - ${title.title}';
  }

  @override
  List<Widget> buildTitleActionButtons(BuildContext context) {
    return [];
  }

  @override
  Widget? buildMenuHeader(BuildContext context) {
    log('build menu header');
    MyAppShowCaseKeys.hideMenu = GlobalKey();
    return Column(
      children: [
        const SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Logo(
              title: 'Flux',
              gradientTitle: 'Cloud',
              clickRedirectHomePage: true,
              clickTextRedirectHomePage: true,
            ),
            Showcase(key: MyAppShowCaseKeys.hideMenu, description: 'Close the side menu', child: const SideBarButton()),
          ],
        ),
        const SizedBox(height: 17),
        const Divider(height: 1),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget wrapSideMenu(Widget child) {
    MyAppShowCaseKeys.sideMenu = GlobalKey();
    return Showcase(key: MyAppShowCaseKeys.sideMenu, description: 'It\'s a menu', child: child);
  }

  @override
  Widget? buildAppBarTitle(BuildContext context) {
    return Column(
      children: [
        AutoSizeText(
          'Flutter Base',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 20),
          maxLines: 1,
        ),
      ],
    );
  }

  @override
  Widget? buildMenuFooter(BuildContext context) {
    return const SideBarFooter();
  }
}

class FlutterBaseAuthConfig extends AuthConfig {
  @override
  FirebaseOptions get firebaseOptions {
    debugPrint('get firebaseOptions: ${AuthFirebaseOptions.fromEnvironment(Constants.environment).currentPlatform}');
    return AuthFirebaseOptions.fromEnvironment(Constants.environment).currentPlatform;
  }

  @override
  Image getImage(context) => Image.asset('assets/images/webp/pouw_background.webp', fit: BoxFit.cover);

  @override
  Widget rightChild(context) => const FractionallySizedBox(
    widthFactor: 0.75,
    child: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revolutionizing Technology',
              textAlign: TextAlign.center,
              softWrap: false,
              maxLines: 3,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            GradientDivider(width: 100, margin: EdgeInsets.symmetric(vertical: 10)),
            GradientText(
              'AuthScreen Example',
              style: TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  String get ssoURL => 'https://pouwdev.runonflux.io';
}
