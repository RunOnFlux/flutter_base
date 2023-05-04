import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:intl/intl_browser.dart';

void configureApp() {
  setUrlStrategy(PathUrlStrategy());
}

Future<void> findLocale() {
  return findSystemLocale();
}
