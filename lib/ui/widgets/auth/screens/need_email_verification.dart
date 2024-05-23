import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/default_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NeedEmailVerificationScreen extends StatefulWidget {
  const NeedEmailVerificationScreen({super.key});

  @override
  State<NeedEmailVerificationScreen> createState() => _NeedEmailVerificationScreenState();
}

class _NeedEmailVerificationScreenState extends State<NeedEmailVerificationScreen> {
  @override
  void initState() {
    super.initState();
    _periodicSubscription = Stream.periodic(const Duration(seconds: 5)).listen((_) => _refreshAuthState());
    _requestNewEmail(true);
  }

  @override
  void dispose() {
    _periodicSubscription?.cancel();
    super.dispose();
  }

  void _requestNewEmail([bool silent = false]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('Request new email verification', name: 'NeedEmailVerificationScreen');
      final String? redirectUrl = GoRouterState.of(context).uri.queryParameters['redirect'];
      context.read<AuthBloc>().add(
            RequestEmailVerificationEvent(
              redirectUrl: redirectUrl,
              silent: silent,
            ),
          );
    });
  }

  StreamSubscription? _periodicSubscription;

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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Verify Email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat',
                          package: 'flutter_base',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Please go to your email and click on the link to verify your email address.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Montserrat',
                          package: 'flutter_base',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: DefaultTextButton.outlined(
                          width: 150,
                          height: 40,
                          onPressed: () {
                            _requestNewEmail();
                          },
                          text: 'Resend',
                        ),
                      ),
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

  void _refreshAuthState() {
    context.read<AuthBloc>().add(const RefreshFirebaseUserEvent());
  }
}
