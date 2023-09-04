import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/logo.dart';
import 'package:flutter_base/ui/widgets/navbar/navbar.dart';
import 'package:flutter_base/ui/widgets/sidemenu/menu_item.dart';
import 'package:flutter_base_example/ui/routes/routes.dart';
import 'package:flutter_base_example/ui/theme/app_theme.dart';
import 'package:flutter_base_example/utils/settings.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tinycolor2/tinycolor2.dart';

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
  @override
  ExampleLoadingNotifier get loadingNotifier => ExampleLoadingNotifier();

  @override
  Widget buildMainApp(BuildContext context) {
    //GetIt.I<NodeCollaterals>().collaterals = loadingNotifier.collaterals;

    Widget mainApp = super.buildMainApp(context);

    //NotificationService().setupFlutterNotifications();
    //NotificationService().router = router;

    /*return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: loadingNotifier),
      ],
      child: mainApp,
    );*/
    return mainApp;
  }

  @override
  AppConfig get config => FlutterBaseAppConfig();
}

class FlutterBaseAppConfig extends AppConfig {
  @override
  String getWindowTitle(AppBodyState body, WindowTitle title) {
    return 'Example App - ${title.title}';
  }

  @override
  List<Widget> buildTitleActionButtons(AppBodyState body, BuildContext context) {
    return [];
  }

  @override
  Widget? buildMenuHeader(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Logo(title: 'Flutter Base', clickRedirectHomePage: true),
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

  @override
  Widget? buildAppBarTitle(BuildContext context) {
    return Column(
      children: [
        AutoSizeText(
          'Flutter Base',
          style: Theme.of(context).textTheme.headlineLarge,
          maxLines: 1,
        ),
      ],
    );
  }

  @override
  Widget? buildMenuFooter(BuildContext context) {
    return Align(
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
    );
  }
}
