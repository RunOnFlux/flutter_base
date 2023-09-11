import 'package:flutter/widgets.dart';

class ScreenInfo with ChangeNotifier {
  AppScreenStateInfo? get currentState => _currentState;

  set currentState(AppScreenStateInfo? state) {
    _currentState = state;
    notifyListeners();
  }

  AppScreenStateInfo? _currentState;
}

class AppScreenStateInfo {
  final int? refreshInterval;
  final IconData? fabIcon;
  Function()? onRefresh;
  Function()? onFAB;

  AppScreenStateInfo({
    this.refreshInterval,
    this.fabIcon,
  });
}
