import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';

class GradientText extends StatelessWidget implements Text {
  const GradientText(this.data,
      {super.key,
      this.style,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.softWrap,
      this.overflow,
      this.textScaleFactor,
      this.maxLines,
      this.semanticsLabel,
      this.textWidthBasis,
      this.textHeightBehavior,
      this.selectionColor,
      this.textScaler,
      this.textSpan,
      this.gradient});

  @override
  final String? data;
  @override
  final TextStyle? style;
  @override
  final StrutStyle? strutStyle;
  @override
  final TextAlign? textAlign;
  @override
  final TextDirection? textDirection;
  @override
  final Locale? locale;
  @override
  final bool? softWrap;
  @override
  final TextOverflow? overflow;
  @override
  final double? textScaleFactor;
  @override
  final int? maxLines;
  @override
  final String? semanticsLabel;
  @override
  final TextWidthBasis? textWidthBasis;
  @override
  final TextHeightBehavior? textHeightBehavior;
  @override
  final Color? selectionColor;
  @override
  final TextSpan? textSpan;

  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    final gradient = this.gradient ?? AppThemeImpl.getOptions(context).textLinearGradient(context);
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(data!,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          locale: locale,
          softWrap: softWrap,
          overflow: overflow,
          textScaler: textScaler,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines,
          semanticsLabel: semanticsLabel,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionColor: selectionColor),
    );
  }

  @override
  final TextScaler? textScaler;
}
