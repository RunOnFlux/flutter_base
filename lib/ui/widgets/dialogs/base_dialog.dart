import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';

abstract class BaseDialog extends StatefulWidget {
  final String title;
  const BaseDialog({super.key, required this.title});
}

abstract class BaseDialogState<T extends BaseDialog> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return Center(
          child: SizedBox(
            width: dialogWidth(context),
            height: dialogHeight(context),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 3,
                    blurRadius: 4,
                    offset: const Offset(5, 5),
                    color: Theme.of(context).cardTheme.shadowColor!,
                  ),
                ],
              ),
              child: Scaffold(
                appBar: AppBar(
                  title: AutoSizeText(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineLarge,
                    maxLines: maxHeaderLines,
                    minFontSize: 8,
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: body(context),
              ),
            ),
          ),
        );
      },
    );
  }

  int get maxHeaderLines => 1;

  double dialogWidth(BuildContext context) => bootStrapValueBasedOnSize(
        sizes: {
          'xl': 700.0,
          'lg': 600.0,
          'md': 500.0,
          'sm': 400.0,
          '': 400.0,
        },
        context: context,
      );

  double dialogHeight(BuildContext context) => 500.0;

  Widget body(BuildContext context) => const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          ),
        ),
      );
}
