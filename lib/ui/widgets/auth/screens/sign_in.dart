import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/extensions/modal_sheet_extensions.dart';
import 'package:flutter_base/ui/app/scope/auth_config_scope.dart';
import 'package:flutter_base/ui/widgets/auth/auth_screen.dart';
import 'package:flutter_base/ui/widgets/default_button.dart';
import 'package:flutter_base/ui/widgets/dialogs/login/login_dialog.dart';
import 'package:flutter_base/ui/widgets/logo.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message_item.dart';
import 'package:flutter_base/utils/validators/password_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, this.type = SignInScreenType.signIn});
  final SignInScreenType type;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    if (width >= 1280) width = width / 2;
    if (width < 560) width = 560;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 56),
        child: SizedBox(
          width: width,
          child: _SignInScreenDelegate(type: type),
        ),
      ),
    );
  }
}

enum SignInScreenType {
  signIn('Sign In'),
  register('Register');

  final String title;

  const SignInScreenType(this.title);

  static SignInScreenType from(String? name) {
    return SignInScreenType.values.firstWhere((element) => element.name == name, orElse: () => signIn);
  }
}

class _SignInScreenDelegate extends StatefulWidget {
  const _SignInScreenDelegate({this.type = SignInScreenType.signIn});
  final SignInScreenType type;

  @override
  State<_SignInScreenDelegate> createState() => _SignInScreenDelegateState();
}

class _SignInScreenDelegateState extends State<_SignInScreenDelegate>
    with AutomaticKeepAliveClientMixin, PasswordValidator {
  FirebaseSignInMethods _selectedMethod = FirebaseSignInMethods.email;

  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmPasswordController;
  TextEditingController? _phoneController;

  final _termsAccepterNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    _phoneController?.dispose();
    _termsAccepterNotifier.dispose();
    _confirmPasswordController?.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final providers = <FirebaseSignInMethods>[];
    final otherMethods = <FirebaseSignInMethods>[];
    for (final method in FirebaseSignInMethods.activeMethods) {
      if (method.isProvider()) {
        providers.add(method);
      } else {
        otherMethods.add(method);
      }
    }
    final config = context.read<AuthScreenConfig>();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Logo2(),
          const SizedBox(
            height: 16,
          ),
          Text(
            widget.type.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 32,
                ),
          ),
          const SizedBox(
            height: 16,
          ),
          Wrap(
            runAlignment: WrapAlignment.spaceAround,
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final method in providers)
                _ProviderSignInButton(
                  method: method,
                  onPressed: _signInPressed,
                ),
              if (config.zelCore)
                _ZelCoreSignInButton(
                  onPressed: () {
                    if (config.isPopup) {
                      context.pop();
                      context.showBottomSheet((_) {
                        return LoginDialog(
                          showMessage: (message) {
                            PopupMessage.of(context).addMessage(PopupMessageItem.success(message: message));
                          },
                        );
                      });
                    }
                  },
                ),
            ],
          ),
          const SizedBox(
            height: 36,
          ),
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'OR',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const Expanded(child: Divider())
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < otherMethods.length; i++)
                () {
                  final method = otherMethods[i];
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _OtherSignInButton(
                        method: method,
                        onPressed: () {
                          setState(() {
                            _selectedMethod = method;
                          });
                        },
                        selected: _selectedMethod == method,
                      ),
                      if (i < otherMethods.length - 1)
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        )
                    ],
                  );
                }()
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) => current.authError != previous.authError,
            builder: (context, state) {
              if (state.authError != null) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: Icon(Icons.error_outline),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      state.authError!.type.errorMessage(false), //state.authError!.type.tr(context),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
          if (_selectedMethod == FirebaseSignInMethods.email) _buildEmailSignIn(),
          if (widget.type == SignInScreenType.register) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                ValueListenableBuilder(
                    valueListenable: _termsAccepterNotifier,
                    builder: (context, value, child) {
                      return Checkbox(
                        value: value,
                        splashRadius: 12,
                        onChanged: (v) async {
                          _termsAccepterNotifier.value = v ?? false;
                        },
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }),
                Expanded(child: _buildTermsAndConditions(context)),
              ],
            ),
          ],
          const SizedBox(height: 22),
          _buildSignInbutton(),
          const SizedBox(height: 16),
          if (widget.type == SignInScreenType.signIn)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (AuthConfigScope.of(context)?.allowSignUp ?? false)
                  Flexible(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            'Don\'t have an account?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: TextButton(
                            onPressed: () {
                              AuthScreen.goToAuthRoute(context, AuthFluxBranchRoute.register);
                            },
                            child: Text(
                              'Sign Up',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    AuthScreen.goToAuthRoute(context, AuthFluxBranchRoute.forgotPassword);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                )
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?', style: Theme.of(context).textTheme.bodyMedium),
                TextButton(
                  onPressed: () {
                    AuthScreen.goToAuthRoute(context, AuthFluxBranchRoute.login);
                  },
                  child: Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                )
              ],
            )
        ],
      ),
    );
  }

  Widget _buildEmailSignIn() {
    return Column(
      children: [
        DefaultAuthPageTextField(
          autoFocus: true,
          controller: _emailController ??= TextEditingController(),
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email required';
            }
            if (EmailValidator.validate(value) == false) {
              return 'Invalid email';
            }
            return null;
          },
        ),
        const SizedBox(
          height: 18,
        ),
        DefaultAuthPageTextField(
          controller: _passwordController ??= TextEditingController(),
          hintText: 'Password',
          obscureText: true,
          errorMaxLines: 2,
          onFieldSubmitted: widget.type == SignInScreenType.signIn
              ? (_) {
                  _signInPressed();
                }
              : null,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: widget.type == SignInScreenType.signIn ? TextInputAction.done : TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password required';
            }
            if (widget.type == SignInScreenType.register && validatePassword(value) == false) {
              return 'Password too weak: minimum 6 characters, 1 uppercase letter, 1 lowercase letter, 1 special character and 1 digit.';
            }
            return null;
          },
        ),
        if (widget.type == SignInScreenType.register) ...[
          const SizedBox(
            height: 18,
          ),
          DefaultAuthPageTextField(
            controller: _confirmPasswordController ??= TextEditingController(),
            hintText: 'Confirm Password',
            obscureText: true,
            onFieldSubmitted: (_) {
              _signInPressed();
            },
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirm password required';
              }
              if (value != _passwordController!.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ]
      ],
    );
  }

  void _signInPressed([FirebaseAuthSignInEvent? signInEvent]) {
    AuthEvent? event = signInEvent;
    if (event == null) {
      if (_formKey.currentState?.validate() == true && _checkConditionsAccepted()) {
        if (_selectedMethod == FirebaseSignInMethods.email) {
          final email = _emailController!.text;
          final password = _passwordController!.text;
          if (widget.type == SignInScreenType.signIn) {
            event = FirebaseAuthSignInEvent.signInByEmail(email, password);
          } else {
            event = FirebaseAuthSignInEvent.signUpByEmail(email, password);
          }
        } else {
          event = FirebaseAuthSignInEvent.signInByPhone(_phoneController!.text, Theme.of(context).brightness);
        }
      } else {
        return;
      }
    }

    debugPrint(event.toString());
    context.read<AuthBloc>().add(event);
  }

  Widget _buildSignInbutton() {
    final otpEvent = context.select<AuthBloc, PhoneSigninRequest?>((b) => b.state.phoneSignInOTPRequest);
    if (otpEvent != null) {
      return StreamBuilder<int>(
        stream: Stream.periodic(1.seconds).map((event) => otpEvent.remainingTime()),
        builder: (context, snapshot) {
          final int? timeRemainingInSeconds = snapshot.data;
          final bool disabled = timeRemainingInSeconds == null || timeRemainingInSeconds <= 0;
          return DefaultTextButton(
            disabled: disabled,
            customActionBuilder: disabled
                ? null
                : (context) {
                    return Text(
                      timeRemainingInSeconds.toString(),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    );
                  },
            onDisabledPressed: () {},
            text: widget.type == SignInScreenType.signIn ? 'Sign In' : 'Sign Up',
            onPressed: _signInPressed,
            height: 46,
          );
        },
      );
    } else {
      return DefaultTextButton(
        text: widget.type == SignInScreenType.signIn ? 'Sign In' : 'Sign Up',
        onPressed: _signInPressed,
        height: 46,
      );
    }
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    final authOptions = AuthConfigScope.of(context)!;
    final String termsAndConditions =
        'By creating an account, you agree to InFlux Technology Limited <a href=\'${authOptions.termsOfServiceUrl}\'>Terms of Service</a> and consent to its <a href=\'${authOptions.privacyPolicyUrl}\'>Privacy Policy</a>.';

    return Html(
        data: termsAndConditions,
        shrinkWrap: true,
        onLinkTap: (url, attributes, element) {
          if (url != null) {
            // context.push(url);
            launchUrlString(url);
          }
        },
        style: {
          'body': Style(fontSize: FontSize(14), fontWeight: FontWeight.w300),
          'a': Style(fontSize: FontSize(14), color: Theme.of(context).primaryColor, fontWeight: FontWeight.w300),
        });
  }

  bool _checkConditionsAccepted() {
    if (widget.type == SignInScreenType.signIn) {
      return true;
    }
    final accepted = _termsAccepterNotifier.value == true;
    if (accepted == false) {
      PopupMessage.of(context).addMessage(
        PopupMessageItem.error(
          message: 'You need to agree to our terms of service and privacy policy in order to create an account.',
        ),
      );
    }
    return accepted;
  }

  @override
  bool get wantKeepAlive => true;
}

class _ProviderSignInButton extends StatelessWidget {
  _ProviderSignInButton({
    required this.method,
    this.onPressed,
  }) : assert(method.authProvider != null);
  final Size size = const Size(120, 50);
  final FirebaseSignInMethods method;
  final void Function(FirebaseProviderAuthEvent event)? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton.icon(
        onPressed: () {
          onPressed?.call(FirebaseProviderAuthEvent.fromFirebaseSignInMethods(method));
        },
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            minimumSize: size,
            backgroundColor: Colors.transparent),
        icon: method.icon,
        label: Text(
          method.providerName,
          maxLines: 1,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
        ),
      ),
    );
  }
}

class _ZelCoreSignInButton extends StatelessWidget {
  const _ZelCoreSignInButton({
    this.onPressed,
  });
  final Size size = const Size(120, 50);
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton.icon(
        onPressed: () {
          onPressed?.call();
        },
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            minimumSize: size,
            backgroundColor: Colors.transparent),
        icon: SizedBox(
          width: 24,
          height: 24,
          child: Image.asset(
            'assets/images/png/zelcore_logo.png',
            package: 'flutter_base',
            width: 24,
            height: 24,
          ),
        ),
        label: Text(
          'ZelCore',
          maxLines: 1,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
        ),
      ),
    );
  }
}

class _OtherSignInButton extends StatelessWidget {
  const _OtherSignInButton({
    required this.method,
    this.selected = false,
    this.onPressed,
  });
  final FirebaseSignInMethods method;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        method.providerName,
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: selected ? Theme.of(context).primaryColor : Colors.grey.shade700,
            ),
      ),
    );
  }
}
