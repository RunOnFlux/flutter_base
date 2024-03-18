import 'package:flutter/widgets.dart';
import 'package:flutter_base/ui/app/config/app_config.dart';

class AppConfigScope extends InheritedWidget {
  const AppConfigScope({
    super.key,
    required super.child,
    required this.config,
  });
  final AppConfig config;

  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfigScope>()?.config;
  }

  @override
  bool updateShouldNotify(covariant AppConfigScope oldWidget) {
    return false;
  }
}
