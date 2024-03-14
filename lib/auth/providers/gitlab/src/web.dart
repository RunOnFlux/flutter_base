import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/foundation.dart';

html.WindowBase? _popup;

Completer<String>? _completer;

/// return customtoken
Future<String> signInWithGitlab() async {
  /// open popup window to gitlab auth [kGitlabSignInUrl]

  if (_completer != null && !_completer!.isCompleted) {
    _completer!.completeError('Canceled');
  }
  _popup = html.window.open(
    'https://pouwdev.runonflux.io:22443/oauth/gitlab/signin',
    'Gitlab Auth',
    'width=500,height=800',
  );

  _completer = Completer<String>();

  debugPrint('open popup window to gitlab auth');

  /// listen to popup window message event
  html.window.onMessage.listen((event) {
    if (event.origin == 'https://pouwdev.runonflux.io:22443') {
      debugPrint('Gitlab.SignInPopup event: ${event.origin} - ${event.data} ');
      try {
        final json = Map.castFrom(event.data);
        if (json['type'] == 'token') {
          if (!_completer!.isCompleted) {
            _completer!.complete(json['token']);
          }
        }
      } catch (e) {
        if (!_completer!.isCompleted) {
          _completer!.completeError(e);
        }
      }
    }
  });

  _subscription = _popupClosed().listen((event) {
    if (event && !_completer!.isCompleted) {
      _completer!.completeError('User closed popup');
    }
  });

  final r = await _completer!.future;
  await _closeWindow();
  return r;
}

Future<void> _closeWindow() async {
  await _subscription?.cancel();
  _popup?.close();
}

Future<void> close() async {
  _completer?.completeError('Canceled');
}

StreamSubscription<bool>? _subscription;
Stream<bool> _popupClosed() async* {
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    yield _popup?.closed ?? true;
  }
}
