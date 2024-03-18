import 'package:flutter/widgets.dart';
import 'package:flutter_base/ui/app/config/auth_config.dart';

class AuthConfigScope extends InheritedWidget {
  const AuthConfigScope({
    super.key,
    required super.child,
    required this.config,
  });
  final AuthConfig config;

  static AuthConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthConfigScope>()?.config;
  }

  @override
  bool updateShouldNotify(covariant AuthConfigScope oldWidget) {
    return false;
  }
}
