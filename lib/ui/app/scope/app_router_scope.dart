import 'package:flutter/widgets.dart';
import 'package:flutter_base/ui/routes/routes.dart';

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
