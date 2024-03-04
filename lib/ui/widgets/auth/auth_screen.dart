import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/copy_button.dart';
import 'package:flutter_base/ui/widgets/responsive_builder.dart';
import 'package:flutter_base/ui/widgets/specifal_focus_nodes.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final smallScreen = context.isSmallWidth();
    final authOptions = AppThemeImpl.getOptions(context).authOptions;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!smallScreen)
                Expanded(
                  child: _AuthScreenLeftSide(
                    image: authOptions.getImage(context),
                    content: authOptions.rightChild(context),
                  ),
                ),
              _AuthScreenRightSide(),
            ],
          ),
          _AuthScreenCloseButton(invertColor: smallScreen),
        ],
      ),
    );
  }

  static void goToAuthRoute(BuildContext context, AuthFluxBranchRoute route) {
    final router = GoRouter.of(context);
    final currentRoute = router.routerDelegate.currentConfiguration.uri;
    final newRoute = currentRoute.replace(path: route.fullPath);
    router.go(newRoute.toString());
  }
}

class _AuthScreenLeftSide extends StatelessWidget {
  final Widget image;
  final Widget content;
  const _AuthScreenLeftSide({
    required this.image,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: Theme.of(context).primaryColorDark),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
            const Color(0xFF0E3672).withOpacity(0.51),
            const Color(0xFF242E61).withOpacity(0.62),
            const Color(0xFF040913).withOpacity(0.80)
          ], stops: const [
            0,
            0.401,
            1
          ]).createShader(bounds),
          blendMode: BlendMode.srcATop,
          child: image,
        ),
        content,
      ],
    );
  }
}

class _AuthScreenRightSide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        //ScrollConfiguration(
        //  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        //  child: Container(),
        //),
        /*const Positioned(
          right: 30,
          top: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LanguageDropDownPicker(),
            ],
          ),
        ),*/
      ],
    );
  }
}

class _AuthScreenCloseButton extends StatelessWidget {
  const _AuthScreenCloseButton({this.invertColor = false});
  final bool invertColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: CloseButton(
        color: invertColor ? Theme.of(context).colorScheme.onBackground : Colors.white,
        onPressed: () {
          if (context.canPop()) {
            context.pop(false);
          }
        },
      ),
    );
  }
}

class DefaultAuthPageTextField extends StatelessWidget {
  const DefaultAuthPageTextField(
      {super.key,
      TextEditingController? controller,
      this.hintText,
      this.errorMaxLines = 1,
      String? text,
      this.labelText,
      this.showClearButton = true,
      this.obscureText = false,
      this.inputFormatters = const [],
      this.onFieldSubmitted,
      this.readOnly = false,
      this.autoFocus = false,
      this.maxLength = 100,
      this.showCopyButton = false,
      this.collapsed = false,
      this.keyboardType,
      this.textInputAction = TextInputAction.next,
      this.validator,
      this.onChanged})
      : assert(text != null || controller != null),
        _text = text,
        _controller = controller;

  final String? _text;
  final bool readOnly;
  final bool autoFocus;
  final TextEditingController? _controller;
  final String? hintText;
  final String? labelText;
  final bool showClearButton;
  final bool obscureText;
  final int errorMaxLines;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final bool collapsed;
  final int maxLength;
  final bool showCopyButton;
  final void Function(String? value)? onChanged;
  final void Function(String? value)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    bool obscureText = this.obscureText;
    String? labelText = this.labelText ?? hintText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (collapsed == false && labelText != null) ...[
          Text(labelText,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.9,
                fontSize: 12,
              )),
          const SizedBox(
            height: 8,
          ),
        ],
        StatefulBuilder(builder: (context, setState) {
          return TextFormField(
              autofocus: autoFocus,
              initialValue: _text,
              autocorrect: false,
              onChanged: onChanged,
              enableInteractiveSelection: true,
              inputFormatters: inputFormatters,
              readOnly: readOnly,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              onFieldSubmitted: onFieldSubmitted,
              controller: _controller,
              textInputAction: textInputAction,
              cursorColor: const Color.fromARGB(255, 2, 85, 254),
              maxLength: maxLength,
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  counterText: '',
                  suffixIcon: _controller == null
                      ? Row(mainAxisSize: MainAxisSize.min, children: [
                          if (showCopyButton) CopyButton(text: _text!),
                          if (this.obscureText)
                            IconButton(
                              focusNode: SkipFocusNode(),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: obscureText ? const Icon(Icons.visibility_off) : const Icon(Icons.remove_red_eye),
                            ),
                        ])
                      : ListenableBuilder(
                          listenable: _controller!,
                          builder: (context, child) {
                            return _controller!.text.isEmpty ? const SizedBox.shrink() : child!;
                          },
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            if (showCopyButton)
                              CopyButton(
                                text: _controller!.text,
                                focusNode: SkipFocusNode(),
                              ),
                            if (this.obscureText)
                              IconButton(
                                focusNode: SkipFocusNode(),
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                icon: obscureText ? const Icon(Icons.visibility_off) : const Icon(Icons.remove_red_eye),
                              ),
                            if (showClearButton)
                              IconButton(
                                focusNode: SkipFocusNode(),
                                onPressed: () {
                                  _controller!.clear();
                                },
                                icon: const Icon(Icons.clear),
                              )
                          ])),
                  isCollapsed: collapsed,
                  errorMaxLines: errorMaxLines,
                  errorStyle: const TextStyle(fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  enabledBorder: collapsed
                      ? InputBorder.none
                      : OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(width: 1.2, color: Theme.of(context).borderColor),
                        ),
                  border: collapsed
                      ? InputBorder.none
                      : OutlineInputBorder(
                          gapPadding: 0,
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(width: 1.2, color: Theme.of(context).borderColor),
                        ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: hintText),
              obscureText: obscureText,
              validator: validator);
        }),
      ],
    );
  }
}
