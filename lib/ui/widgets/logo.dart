import 'package:flutter/material.dart';
import 'package:flutter_base/extensions/router_extension.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/gradients/gradient_text.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
    this.height,
    this.clickRedirectHomePage = false,
    this.title,
    this.gradientTitle,
    this.fontSize = 23.0,
    this.color = Colors.transparent,
    this.onPressed,
  });
  final double? height;
  final bool clickRedirectHomePage;
  final String? title;
  final String? gradientTitle;
  final Color? color;
  final Function()? onPressed;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MaterialButton(
          minWidth: 0,
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: clickRedirectHomePage
              ? () {
                  context.goInitialRoute();
                }
              : onPressed,
          shape: const CircleBorder(),
          color: color,
          child: SvgPicture.asset(
            'assets/images/svg/logo.svg',
            height: height ?? 28,
            package: 'flutter_base',
          ),
        ),
        if (title != null) ...[
          const SizedBox(
            width: 6,
          ),
          Text(
            title!,
            style: TextStyle(
              fontSize: fontSize,
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          )
        ],
        if (gradientTitle != null)
          GradientText(
            gradientTitle!,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w400,
                height: 1,
                letterSpacing: -0.918,
                fontSize: fontSize),
          ),
      ],
    );
  }
}

class Logo2 extends StatelessWidget {
  const Logo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
        boxShadow: [
          Theme.of(context).shadow,
        ],
      ),
      child: SvgPicture.asset(
        'assets/images/svg/logo_2.svg',
        package: 'flutter_base',
      ),
    );
  }
}
