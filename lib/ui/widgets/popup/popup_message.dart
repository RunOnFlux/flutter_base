import 'package:flutter/material.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message_item.dart';
import 'package:flutter_base/ui/widgets/transparent_pointer.dart';

/*class PopupMessage extends StatelessWidget {
  const PopupMessage(
      {super.key,
      this.duration = const Duration(seconds: 5),
      this.message,
      this.richMessage,
      this.maxLines = 1,
      this.copiable = false,
      this.foregroundColor,
      this.color,
      this.icon})
      : assert(message != null || richMessage != null);
  final Duration duration;
  final String? message;
  final Color? color;
  final bool copiable;
  final Color? foregroundColor;
  final IconData? icon;
  final int maxLines;
  final TextSpan? richMessage;

  factory PopupMessage.byType(
      {Key? key,
      required String type,
      int maxLines = 2,
      bool copiable = true,
      Duration duration = const Duration(seconds: 5),
      String? message,
      TextSpan? richMessage}) {
    if (type == 'error') {
      return PopupMessage.error(
        key: key,
        maxLines: maxLines,
        copiable: copiable,
        duration: duration,
        message: message,
        richMessage: richMessage,
      );
    } else if (type == 'warning') {
      return PopupMessage.warning(
        key: key,
        maxLines: maxLines,
        copiable: copiable,
        duration: duration,
        message: message,
        richMessage: richMessage,
      );
    }
    return PopupMessage.success(
      key: key,
      maxLines: maxLines,
      duration: duration,
      message: message,
      richMessage: richMessage,
    );
  }

  factory PopupMessage.error(
      {Key? key,
      int maxLines = 2,
      bool copiable = true,
      Duration duration = const Duration(seconds: 5),
      String? message,
      TextSpan? richMessage}) {
    return PopupMessage(
        key: key,
        duration: duration,
        maxLines: maxLines,
        copiable: copiable,
        richMessage: richMessage,
        message: message,
        icon: Icons.error_outline_rounded);
  }

  factory PopupMessage.warning(
      {Key? key,
      int maxLines = 2,
      bool copiable = true,
      Duration duration = const Duration(seconds: 5),
      String? message,
      TextSpan? richMessage}) {
    return PopupMessage(
        key: key,
        duration: duration,
        maxLines: maxLines,
        copiable: copiable,
        richMessage: richMessage,
        message: message,
        icon: Icons.warning_amber_outlined);
  }

  factory PopupMessage.success(
      {Key? key,
      int maxLines = 1,
      Duration duration = const Duration(seconds: 3),
      String? message,
      TextSpan? richMessage}) {
    return PopupMessage(
        key: key,
        duration: duration,
        maxLines: maxLines,
        richMessage: richMessage,
        message: message,
        icon: Icons.check_circle_outline_rounded);
  }

  bool isEquals(PopupMessage other) {
    return other.message == message || other.richMessage == richMessage;
  }

  void show() {
    if (rootPopupMessageKey.currentState != null) {
      rootPopupMessageKey.currentState!.addMessage(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget child = ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) Icon(icon, color: foregroundColor ?? theme.primaryColor),
                if (icon != null) const SizedBox(width: 8),
                Flexible(
                  child: Text.rich(
                    richMessage ?? TextSpan(text: message),
                    softWrap: false,
                    maxLines: maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: foregroundColor ?? theme.colorScheme.onBackground),
                  ),
                ),
              ],
            )));
    if (copiable) {
      final message = this.message ?? richMessage?.toPlainText();
      assert(message != null, 'Message is null');
      child = InkWell(
          mouseCursor: SystemMouseCursors.copy,
          onTap: () {
            Clipboard.setData(ClipboardData(text: message!));
          },
          child: child);
    } else {
      child = IgnorePointer(child: child);
    }
    return Card(
            shadowColor: theme.shadowColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6), side: BorderSide(color: theme.borderColor)),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: color ?? theme.colorScheme.background,
            child: child)
        .animate()
        .fadeIn()
        .slideY();
  }
}

extension PopupMessageContext on BuildContext {
  void show(PopupMessage message) {
    PopupMessageScope.of(this).addMessage(message);
  }

  void remove(PopupMessage message) {
    PopupMessageScope.of(this).removeMessage(message);
  }
}

class PopupMessageScope extends InheritedWidget {
  const PopupMessageScope(this._state, {super.key, required super.child});

  final PopupMessageWidgetState _state;

  static PopupMessageWidgetState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PopupMessageScope>()!._state;
  }

  @override
  bool updateShouldNotify(covariant PopupMessageScope oldWidget) {
    return false;
  }
}

class PopupMessageWidget extends StatefulWidget {
  const PopupMessageWidget({
    required this.child,
    this.aligment = Alignment.topCenter,
    this.maxMessages = 3,
    super.key,
  });
  final Widget child;
  final Alignment aligment;
  final int maxMessages;

  @override
  State<PopupMessageWidget> createState() => PopupMessageWidgetState();
}

final GlobalKey<PopupMessageWidgetState> rootPopupMessageKey = GlobalKey<PopupMessageWidgetState>();

class PopupMessageWidgetState extends State<PopupMessageWidget> {
  final List<PopupMessage> _messages = [];

  @override
  void initState() {
    super.initState();
  }

  void addMessage(PopupMessage message) {
    if (mounted) {
      setState(() {
        if (_messages.length > widget.maxMessages) {
          _messages.removeAt(0);
        }
        _messages.add(message);
        _scheduleRemoveMessage(message);
      });
    }
  }

  void clearMessages() {
    if (mounted) {
      setState(() {
        _messages.clear();
      });
    }
  }

  void _removeMessage(PopupMessage message) {
    if (mounted) {
      final removed = _messages.remove(message);
      if (removed) {
        setState(() {});
      }
    }
  }

  void removeMessage(PopupMessage message) {
    if (mounted) {
      _scheduleRemoveMessage(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMessageScope(this,
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            Positioned(
              width: 550,
              right: 0,
              top: 0,
              child: IgnorePointer(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  },
                ),
              ),
            ),
          ],
        ));
  }

  void _scheduleRemoveMessage(PopupMessage message) {
    Future.delayed(message.duration, () {
      _removeMessage(message);
    });
  }
}
*/

class PopupMessage extends InheritedWidget {
  const PopupMessage(this._state, {super.key, required super.child});

  final PopupMessageWidgetState _state;

  static PopupMessageWidgetState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PopupMessage>()!._state;
  }

  static void show(BuildContext context, PopupMessageItem message) {
    of(context).addMessage(message);
  }

  @override
  bool updateShouldNotify(covariant PopupMessage oldWidget) {
    return oldWidget._state != _state;
  }
}

final GlobalKey<PopupMessageWidgetState> rootPopupMessageKey = GlobalKey<PopupMessageWidgetState>();

class PopupMessageWidget extends StatefulWidget {
  const PopupMessageWidget(
      {super.key,
      required this.child,
      this.overlayWrapper,
      this.postponeHideWhenNewMessageAdded = false,
      this.aligment = Alignment.topRight,
      this.minInterval = const Duration(milliseconds: 500),
      this.maxMessages = 5});

  final Widget child;

  /// Alignment of the message stack, default is top right
  final Alignment aligment;

  /// Maximum number of messages in the stack
  final int maxMessages;

  /// Minimum interval between messages
  final Duration minInterval;
  final Widget Function(BuildContext context, Widget child)? overlayWrapper;

  /// If true the delete of the message will be postponed when a new message is added
  /// this allow the user to more easily read the messages in the stack
  final bool postponeHideWhenNewMessageAdded;

  @override
  State<PopupMessageWidget> createState() => PopupMessageWidgetState();
}

class PopupMessageWidgetState extends State<PopupMessageWidget> {
  void notify() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final List<PopupMessageItem> messages = [];

  void addMessage(PopupMessageItem message) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastMessage = messages.lastOrNull;
    if (lastMessage != null && lastMessage.isEquals(message)) {
      if (now - _lastMessageTime! < widget.minInterval.inMilliseconds) {
        return;
      }
    }
    if (messages.length > widget.maxMessages) {
      messages.removeAt(0);
    }
    Duration ps = Duration.zero;
    if (widget.postponeHideWhenNewMessageAdded) {
      for (final oldMessage in messages) {
        const d = Duration(milliseconds: 500);
        oldMessage.postponeRemove(d);
        ps = d;
      }
    }
    messages.add(message);
    Future.delayed(ps, () {
      _scheduleRemoveMessage(message);
    });
    (message);
    notify();
  }

  int get messageCount => messages.length;

  int? get _lastMessageTime => messages.lastOrNull?.time.millisecondsSinceEpoch;

  void clearMessages() {
    for (final message in messages) {
      message.remove(context);
    }
    messages.clear();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMessage(this,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.child,
              Overlay(
                initialEntries: [
                  OverlayEntry(builder: (context) => _buildOverlay()),
                ],
              )
            ],
          ),
        ));
  }

  Widget _buildOverlay() {
    if (messages.isEmpty) {
      return const SizedBox.shrink();
    }

    final overlay = Align(alignment: widget.aligment, child: _Overlay(messages: messages));
    if (widget.overlayWrapper != null) {
      return widget.overlayWrapper!(context, overlay);
    }
    return overlay;
  }

  @override
  void dispose() {
    for (final message in messages) {
      message.remove(context);
    }
    messages.clear();

    super.dispose();
  }

  void _scheduleRemoveMessage(PopupMessageItem message) {
    message.scheduleRemove();
  }
}

class _Overlay extends StatelessWidget {
  const _Overlay({super.key, required this.messages});
  final List<PopupMessageItem> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const SizedBox.shrink();
    }
    return TransparentPointer(
      child: FractionallySizedBox(
          widthFactor: 0.45,
          heightFactor: 0.8,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            scrollDirection: Axis.vertical,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return messages[index];
            },
          )),
    );
  }
}

extension PopupMessageContext on BuildContext {
  void show(PopupMessageItem message) {
    PopupMessage.of(this).addMessage(message);
  }
}
