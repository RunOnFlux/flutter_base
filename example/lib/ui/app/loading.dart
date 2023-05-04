import 'package:flutter_base/ui/app/i18n.dart';
import 'package:flutter_base/ui/app/loading_notifier.dart';

class ExampleLoadingNotifier extends LoadingNotifier {
  @override
  Future<void> fetchData() async {
    await MyI18n.loadTranslations();
    loadingComplete = true;
    notifyListeners();
  }
}
