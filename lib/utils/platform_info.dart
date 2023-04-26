import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformInfo {
  bool isDesktopOS() {
    return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
  }

  bool isAppOS() {
    return defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;
  }

  bool isWeb() {
    return kIsWeb;
  }

  PlatformType getCurrentPlatformType() {
    if (kIsWeb) {
      return PlatformType.web;
    }
    if (Platform.isMacOS) {
      return PlatformType.macOS;
    }
    if (Platform.isFuchsia) {
      return PlatformType.fuchsia;
    }
    if (Platform.isLinux) {
      return PlatformType.linux;
    }
    if (Platform.isWindows) {
      return PlatformType.windows;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return PlatformType.iOS;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return PlatformType.android;
    }
    return PlatformType.unknown;
  }
}

enum PlatformType { web, iOS, android, macOS, fuchsia, linux, windows, unknown }
