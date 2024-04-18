import 'package:flutter/widgets.dart';
import 'package:flutter_base/ui/widgets/floating_action_menu.dart';

class ScreenInfo with ChangeNotifier {
  AppScreenStateInfo? get currentState => _currentState;
  ValueNotifier<AppScreenStateInfo?> state = ValueNotifier<AppScreenStateInfo?>(null);

  set currentState(AppScreenStateInfo? newState) {
    _currentState = newState;
    state.value = newState;
    notifyListeners();
  }

  AppScreenStateInfo? _currentState;
}

class AppScreenStateInfo {
  final int? refreshInterval;
  IconData? fabIcon;
  Function()? onRefresh;
  Function()? onFAB;
  List<FloatingMenuItem>? items;
  late String route;

  AppScreenStateInfo({
    this.refreshInterval,
    this.fabIcon,
    this.items,
  });
}

class AppScreenRegistry {
  final Map<String, AppScreenStateInfo> _registry = {};

  AppScreenStateInfo? get(String route) => _registry[route];

  void set(String route, AppScreenStateInfo appScreenStateInfo) {
    _registry[route] = appScreenStateInfo;
  }
}
