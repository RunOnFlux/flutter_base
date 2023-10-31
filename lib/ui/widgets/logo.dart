import 'package:flutter/material.dart';
import 'package:flutter_base/extensions/router_extension.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
    this.height,
    this.clickRedirectHomePage = false,
    this.title,
    this.color = Colors.transparent,
    this.onPressed,
  });
  final double? height;
  final bool clickRedirectHomePage;
  final String? title;
  final Color? color;
  final Function()? onPressed;

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
            )),
        if (title != null) ...[
          const SizedBox(
            width: 6,
          ),
          Text(title!,
              style: TextStyle(
                  fontSize: 18.7, color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.w700))
        ]
      ],
    );
  }
}
