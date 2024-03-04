import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  final String? text;
  const AppBanner({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return Container();
    }
    return Banner(
      message: text!,
      location: BannerLocation.topStart,
      color: Colors.red,
    );
  }
}
