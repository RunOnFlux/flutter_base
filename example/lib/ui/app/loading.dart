import 'package:flutter/foundation.dart';
import 'package:flutter_base/ui/app/i18n.dart';
import 'package:flutter_base/ui/app/loading_notifier.dart';

class ExampleLoadingNotifier extends LoadingNotifier {
  @override
  Future<void> fetchData() async {
    debugPrint('LoadingNotifier started');
    await MyI18n.loadTranslations();
    loadingComplete = true;
    debugPrint('LoadingNotifier notifying');
    notifyListeners();
  }
}
