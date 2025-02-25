import 'package:web/web.dart' as web;

void setHistory(String title, String route) {
  web.window.history.replaceState(null, title, route);
}
