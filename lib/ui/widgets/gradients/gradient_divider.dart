import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';

class GradientDivider extends StatelessWidget {
  const GradientDivider({super.key, this.width, this.margin});
  final double? width;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: 6,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        gradient: AppThemeImpl.getOptions(context).textLinearGradient(context),
      ),
    );
  }
}
