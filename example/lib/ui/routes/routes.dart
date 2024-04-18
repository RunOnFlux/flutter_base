import 'package:flutter/material.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/extensions/modal_sheet_extensions.dart';
import 'package:flutter_base/ui/app/config/auth_config.dart';
import 'package:flutter_base/ui/app/scope/auth_config_scope.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/routes/routes.dart';
import 'package:flutter_base/ui/widgets/auth/auth_screen.dart';
import 'package:flutter_base/ui/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message_item.dart';
import 'package:flutter_base_example/ui/screens/home/home_screen.dart';
import 'package:flutter_base_example/ui/screens/params/params_screen.dart';
import 'package:flutter_base_example/ui/screens/tabs/tabbed_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ExampleAppRouter extends AppRouter {
  ExampleAppRouter._p();
  static final ExampleAppRouter _instance = ExampleAppRouter._p();
  factory ExampleAppRouter() => _instance;

  @override
  List<AbstractRoute> buildRoutes(BuildContext context) {
    final routes = <AbstractRoute>[
      NavigationRoute(
        route: '/',
        body: HomeScreen(),
        title: 'Workers',
        asset: 'assets/images/svg/workers_icon.svg',
        includeInMenu: true,
      ),
      NavigationRoute(
        route: '/disabled',
        body: ExampleTabsScreen(),
        title: 'Disabled',
        icon: Icons.disabled_by_default_outlined,
        includeInMenu: true,
        active: false,
      ),
      NavigationRoute(
        route: '/app/:appName',
        initialLocation: '/app/default',
        body: ParamsScreen(),
        title: 'Params',
        icon: Icons.disabled_by_default_outlined,
        includeInMenu: false,
      ),
      RouteSet(
        title: 'Sub Menu',
        asset: 'assets/images/svg/mining_icon.svg',
        routes: [
          NavigationRoute(
            route: '/1',
            body: ExampleTabsScreen(),
            title: '1',
            icon: Icons.access_alarm_outlined,
            includeInMenu: true,
          ),
          NavigationRoute(
            route: '/2',
            body: ExampleTabsScreen(),
            title: '2',
            icon: Icons.back_hand_outlined,
            includeInMenu: true,
          ),
          NavigationRoute(
            route: '/3',
            body: ExampleTabsScreen(),
            title: '3',
            icon: Icons.three_g_mobiledata_outlined,
            includeInMenu: true,
          ),
        ],
        above: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: FractionallySizedBox(
            widthFactor: 0.75,
            child: Divider(
              thickness: 0.75,
            ),
          ),
        ),
      ),
      RouteSet(
        title: '3 Levels',
        icon: Icons.access_alarm_outlined,
        routes: [
          RouteSet(
            title: 'My Apps',
            icon: Icons.access_alarm_outlined,
            routes: [
              NavigationRoute(
                route: '/4',
                body: ExampleTabsScreen(),
                title: '4',
                icon: Icons.access_alarm_outlined,
                includeInMenu: true,
              ),
            ],
          ),
          RouteSet(
            title: 'Admin',
            icon: Icons.admin_panel_settings_outlined,
            routes: [
              NavigationRoute(
                route: '/5',
                body: ExampleTabsScreen(),
                title: '5',
                icon: Icons.access_alarm_outlined,
                includeInMenu: true,
              ),
              ActionRoute(
                title: 'Nested Action',
                action: (BuildContext context) {
                  debugPrint('nested do something!!');
                  PopupMessageItem.success(message: 'Do Something!!').show(context);
                  context.go('/app/testapp');
                },
                icon: Icons.add,
              ),
            ],
          ),
        ],
      ),
      NavigationRoute(
        route: '/tabs',
        title: 'Tabbed',
        body: ExampleTabsScreen(),
        icon: Icons.tab_outlined,
        includeInMenu: true,
      ),
      NavigationRoute(
        route: '/tabs/1',
        title: 'Tabbed 1',
        body: ExampleTabsScreen(
          initialPage: ExampleTabsScreen.one,
        ),
      ),
      NavigationRoute(
        route: '/tabs/2',
        title: 'Tabbed 2',
        body: ExampleTabsScreen(
          initialPage: ExampleTabsScreen.two,
        ),
      ),
      NavigationRoute(
        route: '/tabs/3',
        title: 'Tabbed 3',
        body: ExampleTabsScreen(
          initialPage: ExampleTabsScreen.three,
        ),
      ),
      ActionRoute(
        title: 'Action',
        action: (BuildContext context) {
          debugPrint('do something!!');
          PopupMessageItem.success(message: 'Do Something!!').show();
          Future.delayed(
            const Duration(seconds: 1),
            () => PopupMessageItem.success(message: 'Do a context Something!!').show(context),
          );
          context.go('/app/testapp');
        },
        icon: Icons.add,
      ),
      ActionRoute(
        title: 'Auth Screen',
        action: (BuildContext context) {
          context.go(AuthFluxBranchRoute.login.fullPath);
        },
        icon: Icons.add,
      ),
      ActionRoute(
        title: 'Auth Popup',
        action: (BuildContext context) {
          context.read<AuthBloc>().setCurrentRoute(AuthFluxBranchRoute.login);
          context.showBottomSheet(
            (context) => BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  (previous.signInByPhoneProcessStarted != current.signInByPhoneProcessStarted) ||
                  (previous.hasFirebaseUser != current.hasFirebaseUser),
              listener: (BuildContext context, AuthState authState) {
                Router.neglect(context, () {
                  if (authState.hasFirebaseUser) {
                    debugPrint('popping because hasFirebaseUser');
                    context.pop();
                  }
                });
              },
              child: AuthScreen(
                isPopup: true,
                zelCore: true,
                child: BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) => previous.currentRoute != current.currentRoute,
                  builder: (BuildContext context, state) {
                    final AuthConfig authConfig = AuthConfigScope.of(context)!;
                    debugPrint('state.currentRoute: ${state.currentRoute.toString()}');

                    final builder = authConfig.authPageBuilder(state.currentRoute!);
                    return builder(null);
                  },
                ),
              ),
            ),
          );
        },
        icon: Icons.add,
      ),
      ActionRoute(
        title: 'Log Out',
        action: (BuildContext context) {
          if (context.read<AuthBloc>().state.fluxLogin == null) {
            debugPrint('Not logged in');
            return;
          }
          ConfirmDialog.showConfirmDialog(
            context: context,
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            onOK: () {
              context.read<AuthBloc>().add(const SignOutEvent());
              PopupMessageItem.success(
                message: 'You have successfully signed out of FluxCloud',
                maxLines: 2,
              ).show(context);
            },
            cancelButton: const Text('Cancel'),
            cancelColor: Colors.red,
            okColor: Theme.of(context).primaryColor,
          );
        },
        icon: Icons.add,
      ),
    ];
    return routes;
  }
}
