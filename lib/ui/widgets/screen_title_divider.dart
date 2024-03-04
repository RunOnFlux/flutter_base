import 'package:flutter/material.dart';

class TitleDivider extends StatelessWidget {
  const TitleDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Divider(
        color: Theme.of(context).dividerColor,
        thickness: 2,
      ),
    );
  }
}
