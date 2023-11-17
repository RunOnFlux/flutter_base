import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../theme/colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppThemeImpl.getOptions(context).appBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: const Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: LoadingIndicator(
            indicatorType: Indicator.lineScale,
            colors: kDefaultRainbowColors,
          ),
        ),
      ),
    );
  }
}
