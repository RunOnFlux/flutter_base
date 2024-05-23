import 'package:flutter/material.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/auth/auth_routes.dart';
import 'package:flutter_base/ui/widgets/auth/auth_screen.dart';
import 'package:flutter_base/ui/widgets/default_button.dart';
import 'package:flutter_base/utils/validators/password_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.oobCode});

  final String oobCode;

  @override
  State<ResetPasswordScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> with PasswordValidator {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.result == AuthResult.passwordResetCompleted) {
            AuthScreen.goToAuthRoute(context, AuthFluxBranchRoute.login, keepParameters: false);
          }
        },
        listenWhen: (previous, current) {
          return current.result != previous.result;
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
                          children: [
                            Icon(
                              Icons.lock,
                              size: 100,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                package: 'flutter_base',
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Please enter your new password below. Minimum 6 characters, 1 uppercase letter, 1 lowercase letter, 1 special character and 1 digit.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            DefaultAuthPageTextField(
                              controller: _passwordController,
                              hintText: 'Password',
                              obscureText: true,
                              errorMaxLines: 2,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password required';
                                }
                                if (validatePassword(value) == false) {
                                  return 'Password too weak: minimum 6 characters, 1 uppercase letter, 1 lowercase letter, 1 special character and 1 digit.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            DefaultAuthPageTextField(
                              controller: _confirmPasswordController,
                              hintText: 'Confirm Password',
                              obscureText: true,
                              onFieldSubmitted: (_) {
                                _resetPassword();
                              },
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm password required';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DefaultTextButton(
                                  text: 'Reset Password',
                                  onPressed: _resetPassword,
                                ),
                                const SizedBox(width: 16),
                                DefaultTextButton.outlined(
                                  text: 'Back to Login',
                                  onPressed: () {
                                    AuthScreen.goToAuthRoute(context, AuthFluxBranchRoute.login);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ))))));
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(CompletePasswordResetEvent(widget.oobCode, _passwordController.text));
    }
  }
}
