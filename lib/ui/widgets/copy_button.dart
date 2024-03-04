import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_svg/svg.dart';

class CopyButton extends StatefulWidget {
  const CopyButton({super.key, required this.text, this.onCopied, this.focusNode});
  final String text;
  final FocusNode? focusNode;
  final void Function(bool animationFinished)? onCopied;

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      focusNode: widget.focusNode,
      tooltip: 'Copy to Clipboard',
      icon: SvgPicture.asset(
        'assets/images/svg/copy.svg',
        package: 'flux_common',
      )
          .animate(controller: _animationController, autoPlay: false)
          .scaleXY(end: 1.3, duration: 100.ms)
          .then(delay: 150.ms)
          .scaleXY(end: 1 / 1.3, duration: 100.ms)
          .swap(builder: (_, child) {
        return Icon(Icons.check, color: Theme.of(context).positiveColor)
            .animate()
            .scaleXY(begin: 0.5)
            .then(delay: 600.ms)
            .scaleXY(begin: 1, end: 0.5)
            .swap(builder: (_, __) => child!);
      }),
      onPressed: _save,
    );
  }

  Future<void> _animate() async {
    return _animationController.forward(from: 0);
  }

  void _save() async {
    if (_animationController.isAnimating) {
      return;
    }
    final text = widget.text;
    try {
      await Clipboard.setData(ClipboardData(text: text));
      widget.onCopied?.call(false);
      await _animate();
      await Future.delayed(const Duration(milliseconds: 1000));
      widget.onCopied?.call(true);
    } catch (e) {
      //
    }
  }
}
