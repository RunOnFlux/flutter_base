import 'package:flutter_base/utils/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExampleSettings extends Settings {
  ExampleSettings._p();
  static final ExampleSettings _instance = ExampleSettings._p();
  factory ExampleSettings() => _instance;

  @override
  void writeDefaults(SharedPreferences prefs) {}

  @override
  String get prefix => 'project_name';

  // Quick access getters

  static bool get darkMode => ExampleSettings().getBool(Setting.darkMode.name, defaultValue: true);
  static String get initialRoute => ExampleSettings().getString(Setting.initialRoute.name, defaultValue: '/');

  static String get setting1 => ExampleSettings().getString(ExampleSetting.setting1.name, defaultValue: 'a value');
}

enum ExampleSetting {
  // General settings
  setting1,
}
