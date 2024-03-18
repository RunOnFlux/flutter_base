import 'package:flutter/widgets.dart';
import 'package:flutter_base/ui/routes/routes.dart';

class AppRouterScope extends InheritedWidget {
  const AppRouterScope({
    super.key,
    required super.child,
    required this.router,
  });
  final AppRouter router;

  static AppRouter of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppRouterScope>()!.router;
  }

  @override
  bool updateShouldNotify(covariant AppRouterScope oldWidget) {
    return false;
  }
}
