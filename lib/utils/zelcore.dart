import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter_base/utils/platform_info.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ZelCore {
  static Future openZelCoreSign(
    String message,
    String callback,
  ) {
    if (PlatformInfo().getCurrentPlatformType() == PlatformType.android) {
      AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data:
              'zel:?action=sign&message=$message&icon=https%3A%2F%2Fraw.githubusercontent.com%2Frunonflux%2Fflux%2Fmaster%2FzelID.svg&callback=$callback',
          flags: <int>[Flag.FLAG_ACTIVITY_CLEAR_TASK, Flag.FLAG_ACTIVITY_NEW_TASK]);
      return intent.launch();
    } else {
      return launchUrlString(
        'zel:?action=sign&message=$message&icon=https%3A%2F%2Fraw.githubusercontent.com%2Frunonflux%2Fflux%2Fmaster%2FzelID.svg&callback=$callback',
        webOnlyWindowName: '_self',
        mode: LaunchMode.externalApplication,
      );
    }
  }

  static String openZelCoreSignAction(
    String message,
    String callback,
  ) {
    return 'zel:?action=sign&message=$message&icon=https%3A%2F%2Fraw.githubusercontent.com%2Frunonflux%2Fflux%2Fmaster%2FzelID.svg&callback=$callback';
  }

  static Future openZelCorePay(
    String address,
    double price,
    String message,
  ) {
    if (PlatformInfo().getCurrentPlatformType() == PlatformType.android) {
      AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data:
              'zel:?action=pay&coin=zelcash&address=$address&amount=$price&message=$message&icon=https%3A%2F%2Fraw.githubusercontent.com%2Frunonflux%2Fflux%2Fmaster%2Fflux_banner.png',
          flags: <int>[Flag.FLAG_ACTIVITY_CLEAR_TASK, Flag.FLAG_ACTIVITY_NEW_TASK]);
      return intent.launch();
    } else {
      return launchUrlString(
        'zel:?action=pay&coin=zelcash&address=$address&amount=$price&message=$message&icon=https%3A%2F%2Fraw.githubusercontent.com%2Frunonflux%2Fflux%2Fmaster%2Fflux_banner.png',
        webOnlyWindowName: '_self',
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
