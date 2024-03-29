import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:tinycolor2/tinycolor2.dart';

class TitledCard extends StatefulWidget {
  final IconData? icon;
  final Color? iconColor;
  final String? title;
  final String? backTitle;
  final String? backToolTip;
  final Widget? titleWidget;
  final Widget child;
  final Widget? backChild;
  final bool? boxShadow;
  final bool internalPadding;
  final bool? gradient;
  final bool? transparent;
  final Color? outlineColor;
  final Color? cardColor;
  final EdgeInsetsGeometry padding;

  const TitledCard({
    super.key,
    this.icon,
    this.iconColor,
    this.title,
    this.titleWidget,
    required this.child,
    this.backTitle,
    this.backToolTip,
    this.backChild,
    this.boxShadow = true,
    this.internalPadding = true,
    this.gradient,
    this.transparent = false,
    this.outlineColor,
    this.cardColor,
    this.padding = const EdgeInsets.all(10.0),
  });

  @override
  TitledCardState createState() => TitledCardState();
}

class TitledCardState extends State<TitledCard> {
  final controller = FlipCardController();
  @override
  Widget build(BuildContext context) {
    var borderRadius = AppThemeImpl.getOptions(context)?.cardBorderRadius ?? 18.7;
    return Padding(
      padding: widget.padding,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: widget.cardColor ?? Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(3, 3),
              color: widget.boxShadow ?? false ? Theme.of(context).cardTheme.shadowColor! : Colors.transparent,
            ),
          ],
        ),
        child: Card(
          color: widget.transparent ?? true ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: widget.outlineColor ??
                  (AppThemeImpl.getOptions(context)?.cardOutlineColor(context) ?? Colors.transparent),
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              decoration: widget.gradient ?? false || (AppThemeImpl.getOptions(context)?.cardGradient ?? false)
                  ? BoxDecoration(
                      gradient: buildLinearGradient(context),
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(widget.internalPadding ? 8.0 : 0),
                    child: Padding(
                      padding: EdgeInsets.all(widget.internalPadding ? 0.0 : 8.0),
                      child: Row(
                        children: [
                          if (widget.icon != null)
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: AppThemeImpl.getOptions(context)?.titledCardIconColor ?? Colors.white,
                                  boxShadow: AppThemeImpl.getOptions(context)?.getTitledCardIconShadow(context),
                                ),
                                child: CircleAvatar(
                                  backgroundColor:
                                      AppThemeImpl.getOptions(context)?.titledCardIconColor ?? Colors.white,
                                  child: Icon(
                                    color: widget.iconColor ?? Theme.of(context).primaryColor,
                                    size: 30,
                                    widget.icon,
                                  ),
                                ),
                              ),
                            ),
                          if (widget.title != null)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: AutoSizeText(
                                  (controller.state?.isFront ?? true)
                                      ? widget.title!
                                      : widget.backTitle ?? widget.title!,
                                  maxLines: 2,
                                  //minFontSize: 6,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ),
                            ),
                          if (widget.titleWidget != null) widget.titleWidget!,
                          //Expanded(child: Container()),
                          widget.backChild == null
                              ? Container()
                              : wrapToolTip(IconButton(
                                  onPressed: () {
                                    controller.toggleCard();
                                  },
                                  icon: const Icon(Icons.flip_sharp),
                                )),
                        ],
                      ),
                    ),
                  ),
                  widget.backChild == null
                      ? widget.child
                      : Expanded(
                          child: FlipCard(
                            controller: controller,
                            fill: Fill.fillBack,
                            direction: FlipDirection.HORIZONTAL,
                            front: widget.child,
                            back: widget.backChild!,
                            flipOnTouch: false,
                            onFlipDone: (isFront) => setState(() {}),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget wrapToolTip(Widget child) {
    if (widget.backToolTip == null) return child;
    return Tooltip(
      message: widget.backToolTip!,
      child: child,
    );
  }
}

class UntitledCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? outlineColor;
  final Color? cardColor;
  final bool? boxShadow;
  final bool? gradient;
  final bool? transparent;

  const UntitledCard({
    super.key,
    required this.child,
    this.outlineColor,
    this.cardColor,
    this.padding,
    this.boxShadow = true,
    this.gradient,
    this.transparent = false,
  });

  @override
  Widget build(BuildContext context) {
    var borderRadius = AppThemeImpl.getOptions(context)?.cardBorderRadius ?? 18.7;
    return Padding(
      padding: padding ?? const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: cardColor ?? Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(3, 3),
              color: boxShadow ?? false ? Theme.of(context).cardTheme.shadowColor! : Colors.transparent,
            ),
          ],
        ),
        child: Card(
          color: transparent ?? true ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color:
                  outlineColor ?? (AppThemeImpl.getOptions(context)?.cardOutlineColor(context) ?? Colors.transparent),
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient ?? false || (AppThemeImpl.getOptions(context)?.cardGradient ?? false)
                    ? buildLinearGradient(context)
                    : null,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

LinearGradient buildLinearGradient(BuildContext context) {
  return LinearGradient(
    colors: [
      Theme.of(context).cardColor.lighten(5),
      Theme.of(context).cardColor,
    ],
    begin: const FractionalOffset(1.0, 0.0),
    end: const FractionalOffset(0.0, 1.0),
    stops: const [0, 0.5],
    tileMode: TileMode.clamp,
  );
}
