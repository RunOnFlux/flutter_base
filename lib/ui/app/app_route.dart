import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom GoRoute sub-class to make the router declaration easier to read
class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
      {List<GoRoute> routes = const [], this.useFade = true})
      : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            //final pageContent = Scaffold(
            //  body: builder(state),
            //  resizeToAvoidBottomInset: false,
            //);
            if (useFade) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: builder(state),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return MaterialPage(child: builder(state));
          },
        );
  final bool useFade;
}
