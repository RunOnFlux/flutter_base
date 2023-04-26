import 'package:flutter/foundation.dart';

import 'i18n.dart';

class LoadingNotifier with ChangeNotifier {
  LoadingNotifier() {
    Future.microtask(() => fetchData());
  }

  bool loadingComplete = false;
  bool isError = false;

  Future<void> fetchData() async {
    await MyI18n.loadTranslations();
    loadingComplete = true;
    notifyListeners();
  }
}
