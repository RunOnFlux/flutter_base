import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/extensions/router_extension.dart';
import 'package:flutter_base/ui/app/config/auth_config.dart';
import 'package:flutter_base/ui/app/scope/auth_config_scope.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/copy_button.dart';
import 'package:flutter_base/ui/widgets/loading_overlay.dart';
import 'package:flutter_base/ui/widgets/popup_message.dart';
import 'package:flutter_base/ui/widgets/responsive_builder.dart';
import 'package:flutter_base/ui/widgets/specifal_focus_nodes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  final Widget child;
  final bool isPopup;

  const AuthScreen({super.key, required this.child, this.isPopup = false});

  @override
  Widget build(BuildContext context) {
    final smallScreen = context.isSmallWidth();

    return BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) => previous.status.isIdle(),
        builder: (context, state) {
          if (state.isIdle) {
            return const Center(child: CircularProgressIndicator());
          }
          wrapper(child) => _DefaultWrapperWidget(child: child);
          if (state.needReauthentication) {
            //wrapper = (child) => _DialogWrapperWidget(child: child);
          }
          return Provider<bool>(
            create: (BuildContext context) => isPopup,
            child: _AuthWrapperWidget(
              child: wrapper(child),
            ),
          );
        });
  }

  static void goToAuthRoute(BuildContext context, AuthFluxBranchRoute route) {
    bool isPopup = context.read<bool>();
    if (isPopup) {
      context.read<AuthBloc>().setCurrentRoute(route);
    } else {
      final router = GoRouter.of(context);
      final currentRoute = router.routerDelegate.currentConfiguration.uri;
      debugPrint(currentRoute.toString());
      final newRoute = currentRoute.replace(path: route.fullPath);
      debugPrint('goToAuthRoute: ${newRoute.toString()}');
      router.go(newRoute.toString());
    }
  }
}

class _DefaultWrapperWidget extends StatelessWidget {
  const _DefaultWrapperWidget({
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final smallScreen = width < 1280;
    final authOptions = AuthConfigScope.of(context)!;
    final child = Scaffold(
      backgroundColor: authOptions.getBackgroundColor(context) ?? Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!smallScreen)
                Expanded(
                  child: _AuthWrapperLeftSide(
                    image: authOptions.getImage(context),
                    content: authOptions.rightChild(context),
                  ),
                ),
              Expanded(child: _AuthWrapperRightSide(child: this.child))
            ],
          ),
          _AuthScreenCloseButton(invertColor: smallScreen)
        ],
      ),
    );
    if (smallScreen) {
      return child;
    }

    final largeScreen = width > 2000;
    if (largeScreen) {
      return child;
    }

    return child;
  }
}

class _AuthWrapperWidget extends StatelessWidget {
  const _AuthWrapperWidget({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous.loading != current.loading,
      builder: (context, state) {
        debugPrint('Auth Screen loading? ${state.loading}');
        return PopupMessageWidget(
          key: GlobalKey(),
          child: LoadingOverlay(
            loading: state.loading,
            colorBarrier: Colors.black54,
            child: child,
          ),
        );
      },
    );
  }
}

class _AuthWrapperLeftSide extends StatelessWidget {
  final Widget image;
  final Widget content;
  const _AuthWrapperLeftSide({
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

class _AuthWrapperRightSide extends StatelessWidget {
  final Widget child;

  const _AuthWrapperRightSide({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: child,
        ),
        const Positioned(
          right: 30,
          top: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //LanguageDropDownPicker(),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuthScreenCloseButton extends StatelessWidget {
  const _AuthScreenCloseButton({
    this.invertColor = false,
  });
  final bool invertColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Consumer<bool>(
        builder: (BuildContext context, bool isPopup, Widget? child) => CloseButton(
          color: invertColor ? Theme.of(context).colorScheme.onBackground : Colors.white,
          onPressed: () {
            debugPrint(context.canPop().toString());
            debugPrint(GoRouter.of(context).routerDelegate.currentConfiguration.toString());
            if (isPopup) {
              context.pop();
            } else {
              close(context);
            }
          },
        ),
      ),
    );
  }

  close(BuildContext context) {
    if (context.isAuthBranch()) {
      debugPrint('default closer');
      if (context.canPop()) {
        context.pop(false);
      } else {
        context.historyBack((success) {
          if (!success) {
            context.goInitialBranch();
          }
        });
      }
    }
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

/// used to display on top of the main screen the challenge pages
/// instead of redirecting to the auth branch, this simplifies the routing
/// and prevent users to navigate back in the history
///
/// the main screen will be hidden when the challenge is visible and its
/// state will be kept in memory
///
/// if any elements needed to be rebuilt when the challenge is passed or the
/// auth status changes, it is mostly handled by using [AuthenticatedBlocMixin]
/// which will recreate a specific bloc and therefore any widgets that depends on it
class AuthChallengeWrapper extends StatelessWidget {
  const AuthChallengeWrapper({super.key, required this.child, this.splashScreen});
  final Widget child;
  final Widget? splashScreen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) => previous.challenge != current.challenge,
        builder: (context, state) {
          final showMain = state.challenge == null || state.challenge!.type == AuthChallengeType.reauthentication;
          return Stack(fit: StackFit.expand, children: [
            if (splashScreen != null && state.challenge == null && !showMain) splashScreen!,
            if (showMain) child else if (state.challenge != null) _buildChallenge(state, context)
          ]);
        });
  }

  Widget _buildChallenge(AuthState state, BuildContext context) {
    final currentRoute = state.challenge!.type.route;
    //final fluxAuthRouteConfig = FluxAuth._instance!.pagesConfig;
    final authBloc = context.read<AuthBloc>();
    final AuthConfig authConfig = AuthConfigScope.of(context)!;
    final builder = authConfig.authPageBuilder(currentRoute);
    final arg = currentRoute.getArg(authBloc.state, GoRouterState.of(context));

    final child = builder(arg);
    return AuthScreen(child: child);
  }
}
