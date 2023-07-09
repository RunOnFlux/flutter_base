import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/bootstrap.dart';

class ProgressDialog extends StatefulWidget {
  final void Function()? onComplete;
  final Future<String> Function() start;
  final String title;
  final String Function(String data)? formatData;

  const ProgressDialog({
    super.key,
    required this.title,
    this.onComplete,
    required this.start,
    this.formatData,
  });

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  bool loading = true;
  String? result;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      var res = await widget.start();
      if (widget.formatData != null) {
        res = widget.formatData!(res);
      }
      setState(() {
        loading = false;
        result = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Center(
        child: SizedBox(
          width: bootStrapValueBasedOnSize(
            sizes: {
              'xxl': 600.0,
              'xl': 600.0,
              'lg': 500.0,
              'md': 450.0,
              'sm': 400.0,
              '': 400.0,
            },
            context: context,
          ),
          height: MediaQuery.of(context).size.height - 100,
          child: WillPopScope(
            onWillPop: () {
              if (widget.onComplete != null) {
                widget.onComplete!();
              }
              return Future.value(true);
            },
            child: Scaffold(
              appBar: AppBar(
                title: AutoSizeText(
                  widget.title,
                  maxLines: 1,
                ),
              ),
              body: loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: AutoSizeText(result!),
                      ),
                    ),
            ),
          ),
        ),
      );
    });
  }
}

class ProgressDialogWithUpdates extends StatefulWidget {
  final void Function()? onComplete;
  final Future<bool> Function(void Function(String)) start;
  final String title;
  final String Function(String data)? formatData;

  const ProgressDialogWithUpdates({
    super.key,
    required this.title,
    this.onComplete,
    required this.start,
    this.formatData,
  });

  @override
  State<ProgressDialogWithUpdates> createState() => _ProgressDialogWithUpdatesState();
}

class _ProgressDialogWithUpdatesState extends State<ProgressDialogWithUpdates> {
  String result = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      var success = await widget.start(updateProgress);
      if (success) {
        updateProgress('Operation completed');
      } else {
        updateProgress('Operation failed');
      }
    });
  }

  void updateProgress(String update) {
    if (!context.mounted) return;
    if (widget.formatData == null) {
      setState(() {
        result += '$update\n';
      });
    } else {
      var formatted = widget.formatData!(update);
      setState(() {
        result += '$formatted\n';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter setState) {
      return Center(
        child: SizedBox(
          width: bootStrapValueBasedOnSize(
            sizes: {
              'xxl': 600.0,
              'xl': 600.0,
              'lg': 500.0,
              'md': 450.0,
              'sm': 400.0,
              '': 400.0,
            },
            context: context,
          ),
          height: MediaQuery.of(context).size.height - 100,
          child: WillPopScope(
            onWillPop: () {
              if (widget.onComplete != null) {
                widget.onComplete!();
              }
              return Future.value(true);
            },
            child: Scaffold(
              appBar: AppBar(
                title: AutoSizeText(
                  widget.title,
                  maxLines: 1,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: AutoSizeText(result),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
