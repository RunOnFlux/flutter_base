import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoRouterContextExtension on BuildContext {
  void goRelative(String location, {Object? extra}) {
    assert(
      !location.startsWith('/'),
      "Relative locations must not start with a '/'.",
    );

    final path = GoRouter.of(this).routerDelegate.currentConfiguration.uri.path;

    String newPath = '$path/$location';

    go(newPath, extra: extra);
  }

  void pushRelative(String location, {Object? extra}) {
    assert(
      !location.startsWith('/'),
      "Relative locations must not start with a '/'.",
    );
    final path = GoRouter.of(this).routerDelegate.currentConfiguration.uri.path;

    String newPath = '$path/$location';

    push(newPath, extra: extra);
  }

  void goInitialRoute() {
    GoRouter.maybeOf(this)?.goInitialRoute();
  }

  void goPreviousPath() {
    GoRouter.maybeOf(this)?.goPreviousPath();
  }
}

String get initialRoute => '/';

extension GoRouterExtension on GoRouter {
  void goInitialRoute() {
    go(initialRoute);
  }

  void goPreviousPath() {
    final currentLocation = routerDelegate.currentConfiguration.uri;
    final previousLocation = currentLocation.removeLastPathSegment();
    go('/$previousLocation');
  }
}

extension on Uri {
  Uri removeLastPathSegment() {
    final pathSegments = this.pathSegments.toList();
    pathSegments.removeLast();
    return replace(pathSegments: pathSegments, queryParameters: {});
  }
}

extension StatefulNavigationShellExtension on StatefulNavigationShellState {
  void goRoot() {
    final currentBranchIndex = currentIndex;
    goBranch(currentBranchIndex, initialLocation: true);
  }
}
