import 'history/native.dart' if (dart.library.js_util) 'history/web.dart' as platform;

mixin History {
  replaceState(String title, String route) {
    platform.replaceState(title, route);
  }
}
