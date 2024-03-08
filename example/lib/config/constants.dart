enum Environment { debug, dev, prod }

class Constants {
  static Map<String, dynamic> _config = {};

  static void setEnvironment(Environment env) {
    _env = env;
    switch (env) {
      case Environment.dev:
        _config = _Config.devConstants;
      case Environment.debug:
        _config = _Config.debugConstants;
      case Environment.prod:
        _config = _Config.prodConstants;
    }
  }

  static late Environment _env;

  static Environment get environment => _env;
  static String get marketplaceUrl => _config[_Config.marketplaceUrl];
  static String? get banner => _config[_Config.banner];
  static bool get comingSoon => _config[_Config.comingSoon];
  static bool get httpLogin => _config[_Config.httpLogin];
}

class _Config {
  static const marketplaceUrl = 'MARKETPLACE_URL';
  static const banner = 'BANNER';
  static const comingSoon = 'COMING_SOON';
  static const httpLogin = 'HTTP_LOGIN';

  static const Map<String, dynamic> debugConstants = {
    marketplaceUrl: 'https://bridge.flux-view.com:8443',
    banner: 'DEBUG',
    comingSoon: false,
    httpLogin: false,
  };
  static const Map<String, dynamic> devConstants = {
    marketplaceUrl: 'https://bridge.flux-view.com:8443',
    banner: 'DEV',
    comingSoon: true,
    httpLogin: false,
  };
  static const Map<String, dynamic> prodConstants = {
    marketplaceUrl: 'https://jetpackbridge.runonflux.io',
    banner: 'BETA',
    comingSoon: true,
    httpLogin: false,
  };
}
