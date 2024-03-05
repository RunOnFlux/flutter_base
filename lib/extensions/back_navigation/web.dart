// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Go back in the browser history.
Future<void> goBack({void Function(bool succeed)? callback}) async {
  final history = html.window.history;
  final currentLocation = html.window.location.href;
  if (history.length > 1) {
    history.back();
  }
  if (callback != null) {
    await _waitLocationChange();
    final newLocation = html.window.location.href;

    callback(currentLocation != newLocation);
  }
}

bool goBackIfReferrerIsNotCurrent() {
  final referrer = html.document.referrer;
  final currentLocation = html.window.location.href;

  if (referrer != currentLocation) {
    goBack();
    return true;
  }
  return false;
}

Future<void> _waitLocationChange() {
  return Future.delayed(const Duration(milliseconds: 100));
}
