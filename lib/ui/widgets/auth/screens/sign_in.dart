import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/ui/widgets/auth/auth_screen.dart';
import 'package:flutter_base/ui/widgets/default_button.dart';
import 'package:flutter_base/ui/widgets/logo.dart';
import 'package:flutter_base/ui/widgets/popup_message.dart';
import 'package:flutter_base/utils/validators/password_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, this.type = SignInScreenType.signIn});
  final SignInScreenType type;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
        child: SizedBox(
          width: 500,
          child: _SignInScreenDelegate(type: type),
        ),
      ),
    );
  }
}

enum SignInScreenType {
  signIn,
  register;

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

  bool get allowSignUp => true; // TODO: Move this to the App Config scope

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
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Logo(),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.type.name,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final method in providers) _ProviderSignInButton(method: method, onPressed: _signInPressed)
              ],
            ),
            const SizedBox(
              height: 36,
            ),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('OR'),
                ),
                Expanded(child: Divider())
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
                  if (allowSignUp)
                    Flexible(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Text('Don\'t have an account?'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: TextButton(
                                onPressed: () {
                                  AuthScreen.goToAuthRoute(context, AuthFluxBranchRoute.register);
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                )),
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
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        AuthScreen.goToAuthRoute(context, AuthFluxBranchRoute.login);
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              )
          ],
        ));
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

    //FluxApp.instance.authSystem.bloc.add(event);
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
            text: 'Sign In',
            onPressed: _signInPressed,
            height: 46,
          );
        },
      );
    } else {
      return DefaultTextButton(
        text: 'Sign In',
        onPressed: _signInPressed,
        height: 46,
      );
    }
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    final String termsAndConditions = 'A terms and conditions document';

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
      PopupMessageScope.of(context).addMessage(
        PopupMessage.error(
            //message: context.authTr.authAgreeToTermsAndConditionsRequired));
            message: 'Agree to terms etc...'),
      );
    }
    return accepted;
  }

  @override
  bool get wantKeepAlive => true;
}

class _ProviderSignInButton extends StatelessWidget {
  _ProviderSignInButton({required this.method, this.onPressed, this.size = const Size(130, 50)})
      : assert(method.authProvider != null);
  final Size size;
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
        style: TextStyle(color: selected ? Theme.of(context).primaryColor : Colors.grey.shade700),
      ),
    );
  }
}
