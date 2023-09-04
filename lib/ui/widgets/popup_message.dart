import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PopupMessage extends StatelessWidget {
  const PopupMessage(
      {super.key,
      this.duration = const Duration(seconds: 5),
      required this.message,
      this.foregroundColor,
      this.color,
      this.icon});
  final Duration duration;
  final String message;
  final Color? color;
  final Color? foregroundColor;
  final IconData? icon;

  factory PopupMessage.error({Key? key, Duration duration = const Duration(seconds: 3), required String message}) {
    return PopupMessage(key: key, duration: duration, message: message, icon: Icons.warning_rounded);
  }

  void show(BuildContext context) {
    PopupMessageScope.of(context).addMessage(this);
  }

  void remove(BuildContext context) {
    PopupMessageScope.of(context).removeMessage(this);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 250),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: color ?? Theme.of(context).primaryColorLight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) Icon(icon, color: foregroundColor ?? Theme.of(context).colorScheme.onBackground),
              if (icon != null) const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY();
  }
}

class PopupMessageScope extends InheritedWidget {
  const PopupMessageScope(this._state, {Key? key, required Widget child}) : super(key: key, child: child);

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
  const PopupMessageWidget({super.key, required this.child, this.aligment = Alignment.topCenter, this.maxMessages = 3});
  final Widget child;
  final Alignment aligment;
  final int maxMessages;

  @override
  State<PopupMessageWidget> createState() => PopupMessageWidgetState();
}

class PopupMessageWidgetState extends State<PopupMessageWidget> {
  final List<PopupMessage> _messages = [];

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
