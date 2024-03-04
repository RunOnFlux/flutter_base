import 'package:flutter/widgets.dart';
import 'package:flutter_base/ui/app/config/auth_config.dart';

class AuthConfigScope extends InheritedWidget {
  const AuthConfigScope({
    Key? key,
    required Widget child,
    required this.config,
  }) : super(key: key, child: child);
  final AuthConfig config;

  static AuthConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthConfigScope>()?.config;
  }

  @override
  bool updateShouldNotify(covariant AuthConfigScope oldWidget) {
    return false;
  }
}
