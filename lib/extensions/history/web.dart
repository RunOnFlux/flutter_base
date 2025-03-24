import 'package:web/web.dart' as web;

replaceState(String title, String route) {
  web.window.history.replaceState(null, title, route);
}
