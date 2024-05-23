import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  const DefaultElevatedButton(
      {super.key,
      this.color,
      this.padding,
      this.textStyle,
      this.minWidth,
      this.elevated = true,
      required this.buttonText,
      this.borderRadius,
      this.onPressed,
      this.height,
      this.width,
      this.foregroundColor,
      this.maxWidth,
      this.maxHeight,
      this.minHeight});
  final Color? color;
  final bool elevated;
  final String buttonText;
  final Function? onPressed;
  final Color? foregroundColor;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final double? borderRadius;
  final double? height;
  final double? width;
  final double? minWidth;
  final double? maxWidth;
  final double? maxHeight;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.secondary;
    final radius = BorderRadius.circular(borderRadius ?? 35);
    return ElevatedButton(
        onPressed: () => onPressed?.call(),
        style: ElevatedButton.styleFrom(
            splashFactory: InkRipple.splashFactory,
            elevation: elevated ? 20 : 0,
            shadowColor: color.withOpacity(0.3),
            fixedSize: Size(width ?? double.infinity, height ?? double.infinity),
            maximumSize: Size(maxWidth ?? double.infinity, maxHeight ?? double.infinity),
            minimumSize: Size(minWidth ?? 150, minHeight ?? 52),
            padding: padding ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 32),
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: radius)),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: textStyle ??
              TextStyle(
                color: foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ));
  }
}

class DefaultTextButton extends StatelessWidget {
  const DefaultTextButton(
      {super.key,
      required this.text,
      this.minHeight,
      this.backgroundColor,
      this.foregroundColor,
      this.disabled = false,
      this.fontWeight,
      this.onDisabledPressed,
      this.borderRadius,
      this.customActionBuilder,
      this.fontSize,
      this.textStyle,
      this.directionality = TextDirection.ltr,
      this.minWidth,
      this.maxWidth,
      this.maxHeight,
      this.width,
      this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      this.actionMaxWidth,
      this.icon,
      this.focusNode,
      this.actionRightPadding,
      this.autoFocus = false,
      this.height,
      this.onPressed,
      this.borderSide,
      this.disabledColor});
  final TextDirection directionality;
  final String text;
  final bool disabled;
  final Widget? icon;
  final VoidCallback? onDisabledPressed;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets padding;
  final void Function()? onPressed;
  final double? height;
  final double? maxHeight;
  final double? minWidth;
  final double? maxWidth;
  final double? width;
  final double? borderRadius;
  final double? minHeight;
  final FocusNode? focusNode;
  final bool autoFocus;
  final BorderSide? borderSide;
  final TextStyle? textStyle;
  final double? actionMaxWidth;
  final Widget Function(BuildContext context)? customActionBuilder;
  final double? actionRightPadding;
  final Color? disabledColor;

  double get _actionMaxWidth {
    if (actionMaxWidth != null) {
      return actionMaxWidth!;
    }
    double defaultWidth = 32;
    if (icon != null) {
      defaultWidth -= 8;
    }
    return defaultWidth;
  }

  static Widget outlined(
      {void Function()? onPressed,
      String? text,
      double? borderRadius,
      double? fontSize,
      double? minWidth,
      double? maxWidth,
      bool disabled = false,
      double? actionMaxWidth,
      double? actionRightPadding,
      double? width,
      Color? borderColor,
      FocusNode? focusNode,
      bool autoFocus = false,
      Color? foregroundColor,
      TextDirection directionality = TextDirection.ltr,
      Widget? icon,
      Color? disabledColor,
      VoidCallback? onDisabledPressed,
      TextStyle? textStyle,
      Widget Function(BuildContext context)? customActionBuilder,
      FontWeight? fontWeight,
      double? height,
      double? minHeight,
      double? maxHeight,
      EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 4)}) {
    return Builder(builder: (context) {
      return DefaultTextButton(
        text: text ?? 'Cancel',
        onPressed: onPressed,
        padding: padding,
        fontWeight: fontWeight,
        icon: icon,
        disabledColor: disabledColor,
        autoFocus: autoFocus,
        focusNode: focusNode,
        onDisabledPressed: onDisabledPressed,
        directionality: directionality,
        minHeight: minHeight,
        disabled: disabled,
        maxHeight: maxHeight,
        textStyle: textStyle,
        actionMaxWidth: actionMaxWidth,
        borderRadius: borderRadius,
        customActionBuilder: customActionBuilder,
        height: height,
        minWidth: minWidth,
        maxWidth: maxWidth,
        actionRightPadding: actionRightPadding,
        width: width,
        borderSide: BorderSide(color: borderColor ?? Theme.of(context).borderColor, width: 1),
        fontSize: fontSize,
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = this.padding;
    if (customActionBuilder != null) {
      padding = padding.copyWith(right: 0);
    }
    final backgroundColor = MaterialStateProperty.resolveWith((states) {
      if (this.backgroundColor == Colors.transparent) {
        return Colors.transparent;
      }
      if (states.contains(MaterialState.disabled)) {
        final color = (disabledColor ?? (this.backgroundColor ?? Theme.of(context).primaryColor));
        return color.withOpacity(color.opacity * 0.25);
      }
      return this.backgroundColor ?? Theme.of(context).primaryColor;
    });
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: disabled && onDisabledPressed != null
          ? () {
              onDisabledPressed!();
            }
          : null,
      child: TextButton(
        focusNode: focusNode,
        autofocus: autoFocus,
        style: ButtonStyle(
            fixedSize: MaterialStateProperty.all(
              Size(width ?? double.infinity, height ?? double.infinity),
            ),
            maximumSize: MaterialStatePropertyAll(Size(maxWidth ?? double.infinity, maxHeight ?? double.infinity)),
            minimumSize: MaterialStatePropertyAll(Size(minWidth ?? 20, minHeight ?? 45)),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textStyle: MaterialStateProperty.all(
              textStyle?.copyWith(fontFamily: 'Montserrat') ??
                  TextStyle(
                    fontWeight: fontWeight ?? FontWeight.w400,
                    fontFamily: 'Montserrat',
                    package: 'flutter_base',
                    fontSize: fontSize ?? 14,
                  ),
            ),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              final foregroundColor = this.foregroundColor ??
                  (backgroundColor.resolve(states).computeLuminance() > 0.6 ? Colors.black : Colors.white);
              if (states.contains(MaterialState.disabled)) {
                return disabledColor ?? foregroundColor.withOpacity(foregroundColor.opacity * 0.25);
              }
              return foregroundColor;
            }),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: borderSide?.copyWith(
                      color: borderSide!.color.withOpacity(
                        borderSide!.color.opacity * (disabled ? 0.25 : 1),
                      ),
                    ) ??
                    BorderSide.none,
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
              ),
            ),
            padding: MaterialStateProperty.all(padding),
            backgroundColor: backgroundColor),
        onPressed: disabled ? null : () => onPressed?.call(),
        child: customActionBuilder == null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: icon!,
                    ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : Stack(
                children: [
                  Positioned(
                    right: actionRightPadding ?? (this.padding.right / 2),
                    top: 0,
                    bottom: 0,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: _actionMaxWidth),
                      child: customActionBuilder!(context),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: this.padding.right),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (icon != null && directionality == TextDirection.ltr)
                              Padding(padding: const EdgeInsets.only(right: 8), child: icon!),
                            Flexible(
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (icon != null && directionality == TextDirection.rtl)
                              Padding(padding: const EdgeInsets.only(left: 8), child: icon!),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
