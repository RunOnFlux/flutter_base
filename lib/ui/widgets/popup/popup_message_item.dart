import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_base/ui/widgets/popup/label.dart';
import 'package:flutter_base/ui/widgets/popup/popup_label_widget.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message.dart';
import 'package:intl/intl.dart';

class PopupMessageItem extends StatefulWidget {
  PopupMessageItem({
    GlobalKey<PopupMessageItemState>? key,
    this.duration = const Duration(seconds: 5),
    this.message,
    this.richMessage,
    this.maxLines = 1,
    this.details,
    this.copiable = false,
    this.hideDetailsTooltipMessage,
    this.showDetailsTooltipMessage,
    this.showDate = true,
    this.detailsBackgroundColor,
    this.textStyle,
    this.detailsTextStyle,
    this.borderColor,
    this.showCloseButton = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.borderRadius = 16,
    this.foregroundColor,
    this.detailsOpenedInitial = false,
    this.pauseRemoveOnHover = true,
    this.label,
    this.color,
    this.icon,
    this.closeButtonColor,
    this.textColor,
  })  : time = DateTime.now(),
        assert(message != null || richMessage != null),
        super(key: key ?? GlobalKey<PopupMessageItemState>());
  final Duration duration;
  final String? message;
  final Color? color;
  final bool copiable;
  final Color? foregroundColor;
  final IconData? icon;
  final int maxLines;
  final InlineSpan? richMessage;
  final bool showDate;
  final DateTime time;
  final bool pauseRemoveOnHover;
  final String? details;
  final bool detailsOpenedInitial;
  final double borderRadius;
  final Color? borderColor;
  final Widget? label;
  final bool showCloseButton;
  final EdgeInsets padding;
  final Color? detailsBackgroundColor;
  final String? hideDetailsTooltipMessage;
  final String? showDetailsTooltipMessage;
  final Color? closeButtonColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final TextStyle? detailsTextStyle;
  GlobalKey<PopupMessageItemState> get _key => key as GlobalKey<PopupMessageItemState>;
  PopupMessageItemState? get _state => _key.currentState;

  factory PopupMessageItem.fromLabel(
      {int maxLines = 3,
      bool copiable = true,
      required PopupMessageLabel label,
      TextSpan? richMessage,
      EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      bool showCloseButton = true,
      bool detailsOpenedInitial = false,
      Duration duration = const Duration(seconds: 5),
      TextStyle? textStyle,
      TextStyle? detailsTextStyle,
      TextSpan? prefix,
      String? details,
      String? message}) {
    return PopupMessageItem(
      duration: duration,
      maxLines: maxLines,
      copiable: copiable,
      textStyle: textStyle,
      detailsTextStyle: detailsTextStyle,
      padding: padding,
      textColor: label.textColor,
      closeButtonColor: label.closeButtonColor,
      detailsBackgroundColor: label.backgroundColorOfLabel,
      borderColor: label.borderColor,
      label: PopupLabelWidget(label: label),
      detailsOpenedInitial: detailsOpenedInitial,
      foregroundColor: label.foregroundColor,
      showDate: false,
      details: details,
      showCloseButton: showCloseButton,
      richMessage: richMessage ?? TextSpan(children: [if (prefix != null) prefix, TextSpan(text: message)]),
      color: label.backgroundColorOfLabel,
      icon: Icons.warning_rounded,
    );
  }

  factory PopupMessageItem.warning(
      {int maxLines = 2,
      bool copiable = true,
      bool showCloseButton = true,
      Duration duration = const Duration(seconds: 5),
      String? message,
      String? details,
      TextStyle? textStyle,
      TextStyle? detailsTextStyle,
      EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      bool detailsOpenedInitial = false,
      TextSpan? richMessage}) {
    return PopupMessageItem.fromLabel(
      label: PopupMessageLabel.warning,
      duration: duration,
      maxLines: maxLines,
      copiable: copiable,
      padding: padding,
      details: details,
      textStyle: textStyle,
      detailsTextStyle: detailsTextStyle,
      showCloseButton: showCloseButton,
      detailsOpenedInitial: detailsOpenedInitial,
      richMessage: richMessage,
      message: message,
    );
  }

  factory PopupMessageItem.success(
      {int maxLines = 4,
      bool copiable = true,
      EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      Duration duration = const Duration(seconds: 5),
      String? message,
      bool showCloseButton = true,
      String? details,
      TextStyle? textStyle,
      TextStyle? detailsTextStyle,
      bool detailsOpenedInitial = false,
      TextSpan? richMessage}) {
    return PopupMessageItem.fromLabel(
      label: PopupMessageLabel.success,
      duration: duration,
      maxLines: maxLines,
      copiable: copiable,
      padding: padding,
      showCloseButton: showCloseButton,
      details: details,
      textStyle: textStyle,
      detailsTextStyle: detailsTextStyle,
      detailsOpenedInitial: detailsOpenedInitial,
      richMessage: richMessage,
      message: message,
    );
  }

  factory PopupMessageItem.update(
      {int maxLines = 2,
      bool copiable = true,
      bool showCloseButton = true,
      EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      Duration duration = const Duration(seconds: 5),
      String? message,
      String? details,
      TextStyle? textStyle,
      TextStyle? detailsTextStyle,
      bool detailsOpenedInitial = false,
      TextSpan? richMessage}) {
    return PopupMessageItem.fromLabel(
      label: PopupMessageLabel.update,
      duration: duration,
      maxLines: maxLines,
      copiable: copiable,
      details: details,
      padding: padding,
      textStyle: textStyle,
      detailsTextStyle: detailsTextStyle,
      showCloseButton: showCloseButton,
      detailsOpenedInitial: detailsOpenedInitial,
      richMessage: richMessage,
      message: message,
    );
  }

  factory PopupMessageItem.error(
      {int maxLines = 2,
      bool copiable = true,
      bool showCloseButton = true,
      EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      Duration duration = const Duration(seconds: 5),
      String? message,
      String? details,
      TextStyle? textStyle,
      TextStyle? detailsTextStyle,
      bool detailsOpenedInitial = true,
      TextSpan? richMessage}) {
    return PopupMessageItem.fromLabel(
      label: PopupMessageLabel.error,
      duration: duration,
      maxLines: maxLines,
      copiable: copiable,
      padding: padding,
      showCloseButton: showCloseButton,
      details: details,
      detailsOpenedInitial: detailsOpenedInitial,
      textStyle: textStyle,
      detailsTextStyle: detailsTextStyle,
      richMessage: richMessage,
      message: message,
    );
  }

  @override
  State<PopupMessageItem> createState() => PopupMessageItemState();

  bool isEquals(PopupMessageItem other) {
    return other.message == message || other.richMessage == richMessage;
  }

  void show([BuildContext? context]) {
    if (context != null) {
      PopupMessage.of(context).addMessage(this);
    } else {
      if (rootPopupMessageKey.currentState != null) {
        rootPopupMessageKey.currentState!.addMessage(this);
      }
    }
  }

  void remove(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _state?.remove();
    });
  }

  void scheduleRemove() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _state?.scheduleRemove();
    });
  }

  void postponeRemove(Duration duration) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _state?.postponeRemove(duration);
    });
  }
}

class PopupMessageItemState extends State<PopupMessageItem> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  TickerFuture? hide() {
    return _controller?.reverse();
  }

  Timer? _removeTimer;
  DateTime? _removeTs;

  void scheduleRemove([Duration? duration]) {
    _removeTimer?.cancel();
    _removeTs = DateTime.now();
    _removeTimer = Timer(duration ?? widget.duration, () {
      remove();
      _removeTs = null;
    });
  }

  void postponeRemove(Duration duration) {
    if (_removeTimer == null) return;
    final now = DateTime.now();
    try {
      final timeRemaining = widget.duration - now.difference(_removeTs!);
      _removeTimer!.cancel();
      scheduleRemove(timeRemaining + duration);
    } catch (e) {}
  }

  Future<void> remove() async {
    void rm() {
      final state = PopupMessage.of(context);
      state.messages.remove(widget);
      state.notify();
    }

    if (hide() == null) {
      rm();
    } else {
      return hide()!.whenComplete(() {
        rm();
      });
    }
  }

  @override
  void initState() {
    _showDetails = widget.detailsOpenedInitial;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 500),
    );
    _controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _removeTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  bool _hovered = false;

  bool _showDetails = false;

  Widget _buildDetails() {
    final theme = Theme.of(context);
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: widget.detailsBackgroundColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: widget.borderColor ?? theme.dividerColor)),
        child: Text(widget.details!,
            style: widget.detailsTextStyle ??
                TextStyle(
                    fontSize: 12, fontFamily: 'Montserrat', fontWeight: FontWeight.w500, color: widget.textColor)));
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(widget.borderRadius);
    final theme = Theme.of(context);
    String? hideDetailsTooltipMessage = widget.hideDetailsTooltipMessage;
    String? showDetailsTooltipMessage = widget.showDetailsTooltipMessage;
    hideDetailsTooltipMessage ??= 'Hide';
    showDetailsTooltipMessage ??= 'Show Details';
    Widget child = ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: SingleChildScrollView(
            padding: widget.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.showCloseButton)
                            Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: _buildCloseButton(),
                            ),
                          if (widget.label != null)
                            widget.label!
                          else ...[
                            if (widget.icon != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(widget.icon, color: widget.foregroundColor),
                              ),
                            if (widget.showDate)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  '${DateFormat('HH:mm:ss').format(widget.time)}: ',
                                  style: TextStyle(fontSize: 11, color: widget.foregroundColor),
                                ),
                              )
                          ],
                          Flexible(
                            child: Text.rich(
                              widget.richMessage ?? TextSpan(text: widget.message!.trim()),
                              maxLines: widget.maxLines,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: widget.textStyle ??
                                  TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: widget.textColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.details != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: IconButton(
                            tooltip: _showDetails ? widget.hideDetailsTooltipMessage : widget.showDetailsTooltipMessage,
                            icon: Icon(
                                _showDetails ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded),
                            onPressed: () {
                              setState(() {
                                _showDetails = !_showDetails;
                              });
                            }),
                      )
                  ],
                ),
                if (widget.details != null && _showDetails) _buildDetails()
              ],
            )));
    if (widget.copiable) {
      final message = widget.message ?? widget.richMessage?.toPlainText();
      assert(message != null, 'Message is null');
      child = InkWell(
          borderRadius: radius,
          mouseCursor: SystemMouseCursors.copy,
          hoverColor: widget.borderColor!.withOpacity(0.2),
          onTap: () {
            Clipboard.setData(ClipboardData(text: widget.details ?? message!));
          },
          child: child);
    }
    child = Card(
            shadowColor: theme.shadowColor,
            shape: RoundedRectangleBorder(
                borderRadius: radius, side: BorderSide(color: widget.borderColor ?? theme.dividerColor)),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: widget.color ??
                (theme.brightness == Brightness.light
                    ? theme.colorScheme.background
                    : theme.dialogTheme.backgroundColor),
            child: child)
        .animate(autoPlay: false, controller: _controller)
        .fade()
        .slideX(begin: 0.8, end: 0, curve: Curves.easeOut);
    if (widget.pauseRemoveOnHover) {
      child = MouseRegion(
        onEnter: (_) {
          _removeTimer?.cancel();
          if (!_hovered) {
            _hovered = true;
            setState(() {});
          }
        },
        onExit: (_) {
          scheduleRemove();
          if (_hovered) {
            _hovered = false;
            setState(() {});
          }
        },
        child: child,
      ).animate(target: _hovered ? 1 : 0).scaleXY(begin: 1, end: 1.05, duration: 200.ms);
    }
    return child;
  }

  Widget _buildCloseButton() {
    return IconButton(
      padding: const EdgeInsets.all(0),
      hoverColor: widget.borderColor!.withOpacity(0.2),
      onPressed: hide,
      iconSize: 16,
      icon: Icon(
        Icons.close,
        color: widget.closeButtonColor,
      ),
      constraints: const BoxConstraints(),
    );
  }
}
