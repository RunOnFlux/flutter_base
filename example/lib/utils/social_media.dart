import 'package:flutter/widgets.dart' show BuildContext;

enum SocialMediaShare {
  twitter,
  discord,

  instagram,
  facebook,
  youtube,
  linkedin;

  String get url {
    switch (this) {
      case SocialMediaShare.twitter:
        return 'https://twitter.com/RunOnFlux';
      case SocialMediaShare.discord:
        return 'https://discord.io/runonflux';
      case SocialMediaShare.facebook:
        return 'https://www.facebook.com/groups/runonflux/';
      case SocialMediaShare.youtube:
        return 'https://www.youtube.com/@ZelLabs';
      case SocialMediaShare.instagram:
        return 'https://www.instagram.com/runonflux_official/';
      case SocialMediaShare.linkedin:
        return 'https://www.linkedin.com/company/flux-official/';
    }
  }

  String icon(BuildContext context) {
    const assetsBase = 'assets/images/svg/';
    return '$assetsBase${name}_icon.svg';
  }
}
