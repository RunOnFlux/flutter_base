import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SimpleData extends StatelessWidget {
  final String title;
  final Widget child;
  final double padding;
  final int? maxLines;

  const SimpleData({
    super.key,
    required this.title,
    required this.child,
    this.padding = 10,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: padding, bottom: padding, left: 5),
      child: Row(children: [
        Expanded(
          flex: 4,
          child: AutoSizeText(
            title,
            maxLines: maxLines ?? 1,
            minFontSize: 6,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 8,
          child: child,
        ),
      ]),
    );
  }
}

class SimpleDataRow extends StatelessWidget {
  final String title;
  final String value;
  final double padding;
  final Color? valueColor;
  final int? maxLines;

  const SimpleDataRow({
    super.key,
    required this.title,
    required this.value,
    this.padding = 10,
    this.valueColor,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleData(
      title: title,
      padding: padding,
      maxLines: maxLines,
      child: AutoSizeText(
        value,
        maxLines: maxLines ?? 1,
        minFontSize: 6,
        style: valueColor == null
            ? Theme.of(context).textTheme.bodyMedium
            : Theme.of(context).textTheme.bodyMedium?.copyWith(color: valueColor),
      ),
    );
  }
}
