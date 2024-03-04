import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/responsive_builder.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay(
      {super.key,
      this.showOverlay,
      this.alignment = Alignment.center,
      this.disableInteraction = true,
      this.child,
      this.loadingOverlayBuilder,
      this.loading = true,
      this.loadingColor,
      this.colorBarrier});

  factory LoadingOverlay.withMessage(
      {Key? key,
      bool? showOverlay,
      bool disableInteraction = true,
      Widget? child,
      String? message,
      Alignment alignment = Alignment.center,
      bool loading = true,
      bool blurBackground = true,
      double sigmaX = 2,
      double sigmaY = 2,
      Color? loadingColor,
      Color? colorBarrier}) {
    return LoadingOverlay(
      key: key,
      alignment: alignment,
      showOverlay: showOverlay,
      disableInteraction: disableInteraction,
      loadingOverlayBuilder: message != null
          ? (context) => _defaultLoadingOverlayBuilder(context, message, blurBackground, sigmaX, sigmaY)
          : null,
      loading: loading,
      loadingColor: loadingColor,
      colorBarrier: colorBarrier,
      child: child,
    );
  }

  static Widget _defaultLoadingOverlayBuilder(
      BuildContext context, String message, bool blurBackground, double sigmaX, double sigmaY) {
    final child = Center(
        child: Dialog(
      insetPadding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        constraints: BoxConstraints(maxHeight: 0.75.sh, minWidth: 150),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Flexible(
              child: Text(message, overflow: TextOverflow.ellipsis, maxLines: 10, textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    ));
    return blurBackground
        ? ColoredBox(
            color: const Color.fromARGB(43, 0, 21, 65),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY, tileMode: TileMode.decal), child: child),
          )
        : child;
  }

  final bool? showOverlay;
  final bool disableInteraction;
  final Widget? child;
  final bool loading;
  final Color? colorBarrier;
  final Color? loadingColor;
  final Alignment alignment;
  final Widget Function(BuildContext context)? loadingOverlayBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: alignment,
      children: [
        child ?? const SizedBox.expand(),
        if (loading) ...[
          if (disableInteraction)
            Positioned.fill(
              child: ColoredBox(
                  color: (showOverlay ?? colorBarrier != null)
                      ? (colorBarrier ?? Theme.of(context).colorBarrier)
                      : Colors.transparent),
            ),
          loadingOverlayBuilder?.call(context) ?? CircularProgressIndicator(color: loadingColor)
        ]
      ],
    );
  }
}
