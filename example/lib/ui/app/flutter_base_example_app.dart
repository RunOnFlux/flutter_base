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
import 'package:flutter_base_example/ui/routes/routes.dart';
import 'package:flutter_base_example/ui/theme/app_theme.dart';
import 'package:flutter_base_example/ui/widgets/footer.dart';
import 'package:flutter_base_example/utils/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'loading.dart';

class FlutterBaseExampleApp extends MinimalApp {
  FlutterBaseExampleApp({Key? key})
      : super(
          key: key,
          router: ExampleAppRouter(),
          settings: ExampleSettings(),
        );

  @override
  registerTheme() {
    GetIt.I.registerSingleton<AppThemeImpl>(ExampleAppTheme());
  }

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
              child: LoadingIndicator(
                indicatorType: Indicator.lineScale,
                colors: kDefaultRainbowColors,
              ),
            ),
            BlocBuilder<LoadingBloc, LoadingState>(
              builder: (context, state) {
                if (state is AppLoadProgressState) {
                  return Text(state.message);
                }
                return Container();
              },
            )
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
  String getWindowTitle(AppBodyState body, WindowTitle title) {
    return 'Example App - ${title.title}';
  }

  @override
  List<Widget> buildTitleActionButtons(BuildContext context) {
    return [];
  }

  @override
  Widget? buildMenuHeader(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Logo(
              title: 'Flux',
              gradientTitle: 'Cloud',
              clickRedirectHomePage: true,
              clickTextRedirectHomePage: true,
            ),
            SideBarButton(),
          ],
        ),
        SizedBox(height: 17),
        Divider(height: 1),
        SizedBox(height: 16),
      ],
    );
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
    /*return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Column(
        children: [
          Row(
            children: [
              ActionMenuItem(
                action: () {
                  showMaterialModalBottomSheet(
                      context: context,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor.lighten().withOpacity(0.9),
                      enableDrag: true,
                      isDismissible: true,
                      builder: (context) {
                        //return const SettingsDialog();
                        return Container();
                      });
                },
                title: 'Settings',
                icon: Icons.settings,
              ),
              ActionMenuItem(
                action: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        //return const FluxOSAboutDialog();
                        return Container();
                      });
                },
                title: 'About',
                icon: Icons.account_box_outlined,
              ),
            ],
          ),
        ],
      ),
    );*/
  }
}

class FlutterBaseAuthConfig extends AuthConfig {
  @override
  FirebaseOptions get firebaseOptions {
    debugPrint('get firebaseOptions: ${AuthFirebaseOptions.fromEnvironment(Constants.environment).currentPlatform}');
    return AuthFirebaseOptions.fromEnvironment(Constants.environment).currentPlatform;
  }

  @override
  Image getImage(context) => Image.asset(
        'assets/images/webp/pouw_background.webp',
        fit: BoxFit.cover,
      );

  @override
  Widget rightChild(context) => const FractionallySizedBox(
        widthFactor: 0.75,
        child: Center(
          child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Revolutionizing Technology',
                  textAlign: TextAlign.center,
                  softWrap: false,
                  maxLines: 3,
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              GradientDivider(
                width: 100,
                margin: EdgeInsets.symmetric(vertical: 10),
              ),
              GradientText(
                'AuthScreen Example',
                style: TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ),
      );

  @override
  String get ssoURL => 'https://pouwdev.runonflux.io';
}
