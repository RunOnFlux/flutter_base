import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_base/utils/platform_info.dart';
import 'package:flutter_base_example/ui/app/flutter_base_example_app.dart';
import 'package:flutter_base_example/utils/settings.dart';

import 'config/configure_nonweb.dart' if (dart.library.html) 'config/configure_web.dart';

Future<void> main() async {
  configureApp();
  WidgetsFlutterBinding.ensureInitialized();

  // Desktop Windows
  if (!PlatformInfo().isWeb() && PlatformInfo().isDesktopOS()) {
    await Window.initialize();
    if (PlatformInfo().getCurrentPlatformType() == PlatformType.windows) {
      await Window.hideWindowControls();
    }
  }

  await ExampleSettings().initialize();

  // Register any singletons here
  //GetIt.I.registerSingleton<NodeList>(NodeList());
  //GetIt.I.registerSingleton<Api>(Api());
  //GetIt.I.registerSingleton<NodeCollaterals>(NodeCollaterals());

  // Optional Push notifications
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  //FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
  findLocale().then(
    (value) => runApp(FlutterBaseExampleApp()),
  );

  // Desktop Windows
  if (!PlatformInfo().isWeb() && PlatformInfo().isDesktopOS()) {
    doWhenWindowReady(() {
      appWindow
        ..minSize = const Size(200, 250)
        ..size = const Size(1280, 720)
        ..alignment = Alignment.center
        ..show();
    });
  }
}
