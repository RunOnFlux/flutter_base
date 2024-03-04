import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/screen_title_divider.dart';

class TitleHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool bootstrap;
  const TitleHeader({super.key, required this.title, required this.icon, this.bootstrap = true});

  @override
  Widget build(BuildContext context) {
    Widget widget = Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 8.0),
          child: Row(
            children: [
              preHeader(context),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(icon, size: 30),
              ),
              AutoSizeText(
                title,
                maxLines: 1,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              postHeader(context),
            ],
          ),
        ),
        const TitleDivider(),
      ],
    );
    if (bootstrap) {
      widget = BootstrapRow(
        children: [
          BootstrapCol(
            fit: FlexFit.tight,
            sizes: 'col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12 col-xxl-12',
            child: widget,
          ),
        ],
      );
    }
    return widget;
  }

  Widget preHeader(BuildContext context) => Container();
  Widget postHeader(BuildContext context) => Container();
}
