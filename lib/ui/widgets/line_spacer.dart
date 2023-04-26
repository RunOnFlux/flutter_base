import 'package:flutter/material.dart';

class LineSpacer extends StatelessWidget {
  final double width;
  final double padding;
  const LineSpacer({
    super.key,
    this.width = 0.5,
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: width,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Divider(
          thickness: 2,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
