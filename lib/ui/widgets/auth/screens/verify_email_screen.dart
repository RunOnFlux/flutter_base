import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/default_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.oobCode, this.changingEmail = false});
  final String oobCode;
  final bool changingEmail;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scheduleVerifyEmail();
  }

  @override
  void didUpdateWidget(covariant VerifyEmailScreen oldWidget) {
    if (widget.oobCode != oldWidget.oobCode) {
      _scheduleVerifyEmail();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _verifyEmail() {
    log('Verify email with oobCode: ${widget.oobCode}', name: 'VerifyEmailScreen');
    context.read<AuthBloc>().add(
          CompleteEmailVerificationEvent(
            widget.oobCode,
            isChangeEmail: widget.changingEmail,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Icon(Icons.email, size: 64, color: Theme.of(context).primaryColor),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Theme.of(context).borderColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Verify Email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                          package: 'flutter_base',
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Please wait while we verify your email address...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Montserrat',
                          package: 'flutter_base',
                        ),
                      ),
                      SizedBox(height: 24),
                      _VerificationProgress(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Timer? _timer;
  void _scheduleVerifyEmail() {
    if (context.read<AuthBloc>().state.error != null) return;
    if (context.read<AuthBloc>().state.firebaseUser?.emailVerified ?? false) return;
    if (context.read<AuthBloc>().state.error == null) {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 1000), () {
        _verifyEmail();
      });
    }
  }
}

class _VerificationProgress extends StatelessWidget {
  const _VerificationProgress();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => current.event != previous.event,
      builder: (context, state) {
        if (state.event is CompleteEmailVerificationEvent) {
          if (state.loading) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(height: 12),
                Text(
                  'Verifying email...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Montserrat',
                    package: 'flutter_base',
                  ),
                ),
                SizedBox(height: 12),
              ],
            );
          }
          if (state.authError != null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: Icon(Icons.error_outline),
                ),
                const SizedBox(height: 12),
                Text(
                  state.authError!.type.errorMessage(false), //state.authError!.type.tr(context),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Montserrat',
                    package: 'flutter_base',
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          }
          if (state.firebaseUser?.emailVerified ?? false) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: Icon(Icons.check_circle_outline_rounded),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Email verified',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Montserrat',
                    package: 'flutter_base',
                  ),
                ),
                const SizedBox(height: 12),
                DefaultTextButton(
                  text: 'Continue',
                  onPressed: () => context.go('/'),
                ),
              ],
            );
          }
        }

        return const SizedBox();
      },
    );
  }
}
