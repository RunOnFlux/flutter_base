import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../utils/bootstrap.dart';

class ProgressDialog extends StatefulWidget {
  final void Function()? onComplete;
  final String title;
  final String appName;
  final String? nodeIP;
  final String Function(String data)? formatData;
  final Future<void> Function(
    String, {
    String? nodeIP,
    Function(String)? onData,
    Function()? onDone,
    Function(String)? onError,
  })
  function;

  const ProgressDialog({
    super.key,
    required this.title,
    this.onComplete,
    required this.function,
    required this.appName,
    this.nodeIP,
    this.formatData,
  });

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  bool loading = true;
  bool complete = false;
  String? result;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      widget.function(
        widget.appName,
        nodeIP: widget.nodeIP,
        onData: (p0) {
          setState(() {
            loading = false;
            result = (widget.formatData != null) ? widget.formatData!(p0) : p0;
          });
        },
        onError: (p0) {
          loading = false;
          result = p0;
        },
        onDone: () {
          if (widget.onComplete != null) {
            widget.onComplete!();
            setState(() {
              complete = true;
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Center(
              child: SizedBox(
                width: bootStrapDoubleBasedOnSize(
                  sizes: {'xxl': 900.0, 'xl': 800.0, 'lg': 700.0, 'md': 600.0, 'sm': 500.0, '': 400.0},
                  context: context,
                ),
                height: constraints.maxHeight - 100,
                child: PopScope(
                  onPopInvokedWithResult: (didPop, result) {},
                  child: Material(
                    elevation: 50,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(32.0),
                    shadowColor: Colors.lightBlueAccent.withValues(alpha: 0.2),
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        side: BorderSide(color: Theme.of(context).splashColor, width: 1.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32.0),
                        child: Container(
                          decoration: BoxDecoration(color: Theme.of(context).cardColor),
                          child: Scaffold(
                            appBar: AppBar(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(child: AutoSizeText(widget.title, maxLines: 1)),
                                    if (!complete)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                  ],
                                ),
                              ),
                              automaticallyImplyLeading: complete,
                            ),
                            body:
                                loading
                                    ? const Center(child: CircularProgressIndicator())
                                    : Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SingleChildScrollView(child: AutoSizeText(result!)),
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
