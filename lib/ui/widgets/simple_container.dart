import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';

class SimpleContainer extends StatelessWidget {
  const SimpleContainer(
      {super.key,
      required this.child,
      this.padding,
      this.margin,
      this.maxWidth,
      this.width,
      this.height,
      this.borderRadius,
      this.minHeight,
      this.borderColor,
      this.showShadow = false,
      this.showBorder = true,
      this.maxHeight,
      this.clipBehavior = Clip.none,
      this.backgroundColor,
      this.gradient});
  final Widget child;
  final double? height;
  final EdgeInsets? padding;
  final double? maxWidth;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? margin;
  final bool showBorder;
  final double? width;
  final double? borderRadius;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Clip clipBehavior;
  final bool showShadow;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    if (gradient == null) {
      backgroundColor = this.backgroundColor ?? Colors.transparent;
      if (showShadow) {
        backgroundColor = Theme.of(context).cardColor;
      }
    }

    return Container(
      clipBehavior: clipBehavior,
      width: width,
      height: height,
      constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity, minHeight: minHeight ?? 0, maxHeight: maxHeight ?? double.infinity),
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: padding ?? const EdgeInsets.symmetric(vertical: 20, horizontal: 36),
      decoration: BoxDecoration(
        boxShadow: [
          if (showShadow)
            const BoxShadow(
              color: Color(0x112B61D1),
              blurRadius: 15,
              offset: Offset(3.75, 3.75),
              spreadRadius: 1.87,
            )
        ],
        gradient: gradient,
        color: backgroundColor,
        border: showBorder ? Border.all(color: borderColor ?? Theme.of(context).borderColor, width: 1.0) : null,
        borderRadius: BorderRadius.circular(borderRadius ?? 25),
      ),
      child: child,
    );
  }
}

class SimpleHeaderContainer extends StatelessWidget {
  const SimpleHeaderContainer(
      {super.key,
      required this.child,
      this.padding,
      this.minHeight,
      this.maxHeight,
      this.maxWidth,
      this.leading,
      this.leadingSpacing = 12,
      this.dividerSpacing,
      this.titleBuilder,
      this.showShadow = false,
      this.margin,
      this.titleStyle,
      this.height,
      this.titleColor,
      this.borderColor,
      this.showDivider = false,
      this.actionCrossAxisAlignment,
      this.borderRadius,
      this.titleAlignment = TextAlign.left,
      this.width,
      this.showBorder = true,
      this.backgroundColor,
      this.titleSpacing,
      required this.title,
      this.clipBehavior = Clip.none,
      this.action});
  final double leadingSpacing;
  final Widget child;
  final Widget? leading;
  final double? height;
  final double? maxWidth;
  final CrossAxisAlignment? actionCrossAxisAlignment;
  final EdgeInsets? padding;
  final Color? titleColor;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? margin;
  final bool showBorder;
  final Color? backgroundColor;
  final String title;
  final Widget? action;
  final double? width;
  final double? borderRadius;
  final double? titleSpacing;
  final TextStyle? titleStyle;
  final Clip clipBehavior;
  final bool showDivider;
  final double? dividerSpacing;
  final TextAlign titleAlignment;
  final Widget Function(String title, BuildContext context)? titleBuilder;
  final bool showShadow;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final a = action != null || titleAlignment != TextAlign.left;
    return SimpleContainer(
      height: height,
      minHeight: minHeight,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      margin: margin,
      width: width,
      clipBehavior: clipBehavior,
      showShadow: showShadow,
      borderColor: borderColor,
      padding: padding,
      borderRadius: borderRadius,
      showBorder: showBorder,
      backgroundColor: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: width != null ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: actionCrossAxisAlignment ?? CrossAxisAlignment.center,
            mainAxisSize: a ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                fit: a ? FlexFit.tight : FlexFit.loose,
                child: Row(
                  mainAxisSize: a ? MainAxisSize.max : MainAxisSize.min,
                  children: [
                    if (leading != null) ...[leading!, SizedBox(width: leadingSpacing)],
                    Flexible(
                        fit: a ? FlexFit.tight : FlexFit.loose,
                        child: titleBuilder?.call(title, context) ??
                            Text(title,
                                maxLines: 1,
                                textAlign: titleAlignment,
                                overflow: TextOverflow.ellipsis,
                                style: titleStyle?.copyWith(color: titleColor) ??
                                    Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600)))
                  ],
                ),
              ),
              if (action != null) action!
            ],
          ),
          SizedBox(height: titleSpacing ?? 8),
          if (showDivider) ...[const Divider(), SizedBox(height: dividerSpacing ?? titleSpacing ?? 8)],
          Flexible(child: child),
          SizedBox(height: titleSpacing ?? 8)
        ],
      ),
    );
  }
}
