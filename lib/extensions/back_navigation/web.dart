import 'package:web/web.dart' as web;

/// Go back in the browser history.
Future<void> goBack({void Function(bool succeed)? callback}) async {
  final history = web.window.history;
  final currentLocation = web.window.location.href;
  if (history.length > 1) {
    history.back();
  }
  if (callback != null) {
    await _waitLocationChange();
    final newLocation = web.window.location.href;

    callback(currentLocation != newLocation);
  }
}

bool goBackIfReferrerIsNotCurrent() {
  final referrer = web.document.referrer;
  final currentLocation = web.window.location.href;

  if (referrer != currentLocation) {
    goBack();
    return true;
  }
  return false;
}

Future<void> _waitLocationChange() {
  return Future.delayed(const Duration(milliseconds: 100));
}
