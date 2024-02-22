import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';

class DefaultElevatedButton extends StatelessWidget {
  const DefaultElevatedButton(
      {super.key,
      this.color,
      this.padding,
      this.textStyle,
      this.elevated = true,
      required this.buttonText,
      this.borderRadius,
      this.onPressed,
      this.height,
      this.width,
      this.foregroundColor});
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
          minimumSize: Size(width ?? 150, height ?? 52),
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
      ),
    );
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
      this.onDisabledPressed,
      this.borderRadius,
      this.customActionBuilder,
      this.fontSize,
      this.textStyle,
      this.directionality,
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
  final TextDirection? directionality;
  final String text;
  final bool disabled;
  final Widget? icon;
  final VoidCallback? onDisabledPressed;
  final double? fontSize;
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
      TextDirection? directionality,
      Widget? icon,
      Color? disabledColor,
      VoidCallback? onDisabledPressed,
      TextStyle? textStyle,
      Widget Function(BuildContext context)? customActionBuilder,
      double? height,
      double? minHeight,
      double? maxHeight,
      EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 4)}) {
    return Builder(builder: (context) {
      return DefaultTextButton(
        text: text ?? 'Cancel',
        onPressed: onPressed,
        padding: padding,
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
                textStyle?.copyWith(fontFamily: 'Montserrat', package: 'flux_common') ??
                    TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                        package: 'flux_common',
                        fontSize: fontSize ?? 14)),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return disabledColor ?? (foregroundColor ?? Colors.white).withOpacity(0.5);
              }
              return foregroundColor ?? Colors.white;
            }),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: borderSide ?? BorderSide.none,
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
              ),
            ),
            padding: MaterialStateProperty.all(padding),
            // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: MaterialStateProperty.all(backgroundColor ?? Theme.of(context).primaryColor),
          ),
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
                    Text(text, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                            child: customActionBuilder!(context))),
                    Positioned.fill(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: this.padding.right),
                          child: Row(
                            textDirection: directionality,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (icon != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: icon!,
                                ),
                              Text(text, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
    );
  }
}
