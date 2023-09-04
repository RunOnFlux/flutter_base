import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/utils/config.dart';

class BackgroundThemeBuilder extends StatelessWidget {
  const BackgroundThemeBuilder(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(gradient: theme.backgroundGradient, color: theme.colorScheme.background),
      child: theme.isLight
          ? child
          : Stack(
              fit: StackFit.expand,
              children: [
                _buildGradientEllipsis(const Color.fromRGBO(0, 117, 255, 0.2), const Offset(-700, -500), context),
                _buildGradientEllipsis(const Color.fromRGBO(64, 152, 255, 0.2), const Offset(400, -900), context, 1400),
                _buildGradientEllipsis(const Color.fromRGBO(64, 152, 255, 0.2), const Offset(991, 620), context),
                child
              ],
            ),
    );
  }

  Widget _buildGradientEllipsis(Color color, Offset offset, BuildContext context, [double size = 1200]) {
    final relativeOffset = _getRelativeOffset(offset, context);
    return Positioned(
        left: relativeOffset.dx,
        top: relativeOffset.dy,
        width: size,
        height: size,
        child: DecoratedBox(decoration: BoxDecoration(gradient: Theme.of(context).ellipsisGradient(color))));
  }

  Offset _getRelativeOffset(Offset offset, BuildContext context) {
    final size = MediaQuery.of(context).size;

    const designSize = kDesignSize;
    final widthRatio = size.width / designSize.width;
    final heightRatio = size.height / designSize.height;
    return Offset(offset.dx * widthRatio, offset.dy * heightRatio);
  }
}
