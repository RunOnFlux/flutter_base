import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/ui/widgets/dialogs/login/login_dialog.dart';
import 'package:flutter_base/ui/widgets/dialogs/login/login_phrase_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FirstCard extends StatefulWidget {
  final double left;
  final double width;
  final Matrix4 transform;
  final Function() next;
  final Function(String) showMessage;

  const FirstCard({
    super.key,
    required this.left,
    required this.width,
    required this.transform,
    required this.next,
    required this.showMessage,
  });

  @override
  State<FirstCard> createState() => _FirstCardState();
}

class _FirstCardState extends State<FirstCard> with ZelCoreWebSockets {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginPhraseProvider>(
      builder: (_, loginProvider, __) => Positioned(
        left: widget.left,
        top: 0,
        child: SizedBox(
          width: widget.width,
          height: 350,
          child: Transform(
            transform: widget.transform,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  'Sign in with FluxID',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: Theme.of(context).primaryColor, fontSize: 36),
                ),
                AutoSizeText(
                  'Enter your FluxID and Signature\n\nto sign in to your account',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: loginProvider.loginPhrase == null ? 8 : 0,
                      sigmaY: loginProvider.loginPhrase == null ? 8 : 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            openZelCore(
                              loginProvider.loginPhrase!,
                              () {},
                              context.read<AuthBloc>(),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Login',
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AutoSizeText(
                            'or',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            widget.next();
                          },
                          icon: const Icon(Icons.qr_code_scanner_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                      'Don\'t have a FluxID?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: InkWell(
                        onTap: () {
                          launchUrlString(
                            'https://zelcore.io/',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: AutoSizeText(
                          'Get ZelCore!',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () {
                      launchUrlString(
                        'https://cloud.runonflux.io/fluxid',
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    child: AutoSizeText(
                      'Learn about FluxID',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
