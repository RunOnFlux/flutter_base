import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/auth/auth_screen.dart';
import 'package:flutter_base/ui/widgets/default_button.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message_item.dart';
import 'package:flutter_base/ui/widgets/simple_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailAlreadySentOneTime.dispose();
    _canSendEmail.dispose();
    _emailController.dispose();
    super.dispose();
  }

  int _coolDownTime = 0;
  Stream<int> _coolDownTimer() async* {
    for (var i = _coolDownTime; i >= 0; i--) {
      yield i;
      await Future.delayed(const Duration(seconds: 1));
    }
    _canSendEmail.value = true;
  }

  void _startCoolDownTimer() {
    _canSendEmail.value = false;
    setState(() {
      _coolDownTime = 60;
    });
  }

  final _emailAlreadySentOneTime = ValueNotifier(false);

  final _canSendEmail = ValueNotifier(true);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          final authExtra = state.result;
          final bool isEmailSent = authExtra == AuthResult.emailSent;
          if (isEmailSent) {
            _emailAlreadySentOneTime.value = true;
            _startCoolDownTimer();
          }
        },
        listenWhen: (previous, current) {
          return previous.result != current.result;
        },
        child: Center(
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
              child: SizedBox(
                  width: 500,
                  child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 120,
                            color: Theme.of(context).strokeColor,
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Forgot Password?',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            'Please enter your email address below. We will send you an email with a link to reset your password.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ValueListenableBuilder(
                            valueListenable: _emailAlreadySentOneTime,
                            builder: (context, value, _) {
                              if (value == false) {
                                return const SizedBox();
                              }
                              return SimpleContainer(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 48,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      'Email sent',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'We have sent an email to ${_emailController.text} with a link to reset your password. Please check your inbox and follow the instructions in the email to reset your password.',
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          DefaultAuthPageTextField(
                            hintText: 'Email',
                            controller: _emailController,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Email required';
                              }
                              if (EmailValidator.validate(value!) == false) {
                                return 'Invalid email';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [_buildCoolDownTimer()],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          SizedBox(
                            height: 42,
                            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                              Expanded(
                                child: ValueListenableBuilder(
                                    valueListenable: _canSendEmail,
                                    builder: (context, value, _) {
                                      return DefaultTextButton(
                                        text: _emailAlreadySentOneTime.value ? 'Resend' : 'Send',
                                        disabled: value == false,
                                        onDisabledPressed: () {
                                          PopupMessage.of(context).addMessage(
                                            PopupMessageItem.warning(
                                              message:
                                                  'Please wait for the cooldown time to finish before sending another email.',
                                            ),
                                          );
                                        },
                                        onPressed: () {
                                          if (_formKey.currentState?.validate() == true) {
                                            context.read<AuthBloc>().add(
                                                  ResetPasswordEvent(_emailController.text),
                                                );
                                          }
                                        },
                                      );
                                    }),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              Expanded(
                                child: DefaultTextButton.outlined(
                                    text: 'Back to Sign In',
                                    onPressed: () {
                                      AuthScreen.goToAuthRoute(context, AuthFluxBranchRoute.login);
                                    }),
                              )
                            ]),
                          ),
                        ]),
                  ))),
        ));
  }

  Widget _buildCoolDownTimer() {
    return StreamBuilder<int>(
      stream: _coolDownTimer(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null || data == 0) {
          return const SizedBox();
        }

        return Text('${data}s');
      },
    );
  }
}
