//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import firebase_auth
import firebase_core
import macos_window_utils
import package_info_plus
import shared_preferences_foundation
import url_launcher_macos
import window_size

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FLTFirebaseAuthPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseAuthPlugin"))
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
  MacOSWindowUtilsPlugin.register(with: registry.registrar(forPlugin: "MacOSWindowUtilsPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
  WindowSizePlugin.register(with: registry.registrar(forPlugin: "WindowSizePlugin"))
}
