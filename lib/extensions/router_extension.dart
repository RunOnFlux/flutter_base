import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'back_navigation/web.dart' if (dart.library.io) 'back_navigation/native.dart' as platform;

extension GoRouterContextExtension on BuildContext {
  /// go to a sub route of the current route
  ///
  /// .i.e. if the current route is '/home' and you want to go to '/home/settings'
  /// you can use this method with 'settings' as the location
  void goRelative(String location, {Object? extra}) {
    assert(
      !location.startsWith('/'),
      "Relative locations must not start with a '/'.",
    );

    final path = GoRouter.of(this).routerDelegate.currentConfiguration.uri.path;

    String newPath = '$path/$location';

    go(newPath, extra: extra);
  }

  // void goPreviousPath() {
  //   GoRouter.of(this).goPreviousPath();
  // }

  /// go back in the browser history
  void historyBack(void Function(bool)? callback) {
    GoRouter.of(this).goBack(callback: callback);
  }

  Future<T?> pushRelative<T>(String location, {Object? extra}) {
    assert(
      !location.startsWith('/'),
      "Relative locations must not start with a '/'.",
    );
    final path = GoRouter.of(this).routerDelegate.currentConfiguration.uri.path;

    String newPath = '$path/$location';

    return push<T>(newPath, extra: extra);
  }

  /// go to the initial route of the app
  void goInitialRoute() {
    GoRouter.of(this).goInitialRoute();
  }

  /// go to the initial route of the current branch if there is one
  void goInitialBranchRoute() {
    final shell = StatefulNavigationShell.maybeOf(this);
    if (shell != null) {
      final currentBranch = shell.currentBranch;
      final initialLocation = currentBranch.initialLocation;
      if (initialLocation != null) {
        go(initialLocation);
      }
    }
  }

  /// shortcut to the current path
  String get currentPath => GoRouter.of(this).currentPath;
  Uri get currentUri => GoRouter.of(this).currentUri;

  /// go to the initial route of the current branch or the initial route of the app
  /// if there is no branch
  void goInitialBranch() {
    final shell = StatefulNavigationShell.maybeOf(this);
    if (shell != null) {
      shell.goBranch(0);
    } else {
      goInitialRoute();
    }
  }
}

extension GoRouterExtension on GoRouter {
  /// go to the initial route of the app
  void goInitialRoute() {
    go('/');
  }

  /// shortcut to the current path
  String get currentPath => currentUri.path;
  Uri get currentUri => routerDelegate.currentConfiguration.uri;

  /// go to the root of the current branch using the navigator
  /// this will pop all the routes until the first one
  void goBranchRootRoute() {
    final navigator = routerDelegate.navigatorKey.currentState;
    if (navigator != null) {
      debugPrint('goBranchRootRoute');
      navigator.popUntil((route) => route.isFirst);
    }
  }

// void goPreviousPath() {
//   final pathSegments = routerDelegate.currentConfiguration.uri.pathSegments;
//   if (pathSegments.isNotEmpty) {
//     final newPath =
//         pathSegments.sublist(0, pathSegments.length - 1).join('/');
//     go('/$newPath');
//   }
// }
}

extension StatefulNavigationShellExtension on StatefulNavigationShellState {
  /// go to the initial location of the branch
  void goInitialLocation() {
    final currentBranchIndex = currentIndex;
    goBranch(currentBranchIndex, initialLocation: true);
  }

  StatefulShellBranch get currentBranch => route.branches[currentIndex];
}

extension GoBackRouterExtension on GoRouter {
  /// go back in the browser history
  void goBack({void Function(bool succeed)? callback}) {
    platform.goBack(callback: callback);
  }

  bool goBackIfReferrerIsNotCurrent() {
    return platform.goBackIfReferrerIsNotCurrent();
  }
}
