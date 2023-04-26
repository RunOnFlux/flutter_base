import 'package:shared_preferences/shared_preferences.dart';

abstract class Settings {
  String get prefix => 'minimal_ui';

  SharedPreferences? _prefs;

  Future<SharedPreferences> initialize() async {
    return SharedPreferences.getInstance().then((value) {
      _prefs = value;
      if (!_prefs!.containsKey('$prefix:darkMode')) {
        _prefs!.setBool('$prefix:darkMode', true);
      }
      writeDefaults(_prefs!);
      return Future.value(_prefs);
    });
  }

  void writeDefaults(SharedPreferences prefs);

  bool getBool(String setting, {bool defaultValue = false}) {
    return _prefs!.getBool(_formatKey(setting)) ?? defaultValue;
  }

  setBool(String setting, bool value) {
    _prefs!.setBool(_formatKey(setting), value);
  }

  String getString(String setting, {String defaultValue = ''}) {
    return _prefs!.getString(_formatKey(setting)) ?? defaultValue;
  }

  setString(String setting, String value) {
    _prefs!.setString(_formatKey(setting), value);
  }

  int getInt(String setting, {int defaultValue = 0}) {
    return _prefs!.getInt(_formatKey(setting)) ?? defaultValue;
  }

  setInt(String setting, int value) {
    _prefs!.setInt(_formatKey(setting), value);
  }

  double getDouble(String setting, {double defaultValue = 0}) {
    return _prefs!.getDouble(_formatKey(setting)) ?? defaultValue;
  }

  setDouble(String setting, double value) {
    _prefs!.setDouble(_formatKey(setting), value);
  }

  String _formatKey(String setting) {
    return '$prefix:$setting';
  }
}

enum Setting {
  // General settings
  darkMode,
  //
  initialRoute,
}
