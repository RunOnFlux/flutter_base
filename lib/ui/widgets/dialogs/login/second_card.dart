import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/auth/service/auth_service.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/dialogs/login/login_dialog.dart';
import 'package:flutter_base/ui/widgets/dialogs/login/login_phrase_provider.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message_item.dart';
import 'package:flutter_base/utils/zelcore.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SecondCard extends StatefulWidget {
  final double left;
  final double width;
  final Matrix4 transform;
  final Function() prev;
  final StateSetter setState;
  final Function(String) showMessage;

  const SecondCard({
    super.key,
    required this.left,
    required this.width,
    required this.transform,
    required this.prev,
    required this.setState,
    required this.showMessage,
  });

  @override
  State<SecondCard> createState() => _SecondCardState();
}

class _SecondCardState extends State<SecondCard> with TickerProviderStateMixin, ZelCoreWebSockets {
  bool showQRCard = true;

  TextEditingController messageTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController signatureTextController = TextEditingController();

  String zelCoreAction = '';

  ImageProvider<Object>? fluxLogo;

  @override
  void initState() {
    super.initState();
    fluxLogo = const AssetImage(
      'assets/images/png/flux_symbol_blue_white.png',
      package: 'flutter_base',
    );
  }

  @override
  Widget build(BuildContext context) {
    const edgeInsets = EdgeInsets.only(
      left: 8.0,
      right: 8.0,
      bottom: 10,
    );
    final isSmallScreen = bootStrapValueBasedOnSize(
      sizes: {
        'xxl': false,
        'xl': false,
        'lg': false,
        'md': false,
        'sm': true,
        '': true,
      },
      context: context,
    );
    final buttonStyle = isSmallScreen
        ? Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)
        : Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white);
    return Consumer<LoginPhraseProvider>(
      builder: (_, loginProvider, __) {
        if (loginProvider.loginPhrase != null) {
          zelCoreAction = ZelCore.openZelCoreSignAction(
            loginProvider.loginPhrase!,
            callbackValue(),
          );
        }
        return Positioned(
          left: widget.left,
          top: 0,
          child: SizedBox(
            width: widget.width,
            child: Transform(
              transform: widget.transform,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 300,
                    child: AnimatedCrossFade(
                      crossFadeState: showQRCard ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 500),
                      firstChild: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: loginProvider.loginPhrase == null ? 8 : 0,
                                sigmaY: loginProvider.loginPhrase == null ? 8 : 0,
                              ),
                              child: QrImageView(
                                backgroundColor: Colors.white,
                                embeddedImage: fluxLogo,
                                size: 230,
                                errorCorrectionLevel: QrErrorCorrectLevel.L,
                                data: zelCoreAction,
                              ),
                            ),
                          ),
                          AutoSizeText(
                            loginProvider.status ?? 'Scan to open ZelCore on your mobile device',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      secondChild: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: edgeInsets,
                              child: _buildMessageField(context),
                            ),
                            Padding(
                              padding: edgeInsets,
                              child: _buildAddressField(context),
                            ),
                            Padding(
                              padding: edgeInsets,
                              child: _buildSignatureField(context),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                doManualLogin(
                                  addressTextController.text,
                                  messageTextController.text,
                                  signatureTextController.text,
                                  () {}, // no need to pop the context here, the WS listener will take care of it.
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Sign In',
                                  style: buttonStyle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          widget.prev();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Back',
                            style: buttonStyle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ElevatedButton(
                          onPressed: showQRCard
                              ? null
                              : () {
                                  widget.setState(() {
                                    showQRCard = true;
                                  });
                                },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'QR Code',
                              style: buttonStyle,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: showQRCard
                            ? () {
                                widget.setState(() {
                                  showQRCard = false;
                                });
                              }
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Manual Signing',
                            style: buttonStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void doManualLogin(
    String zelid,
    String loginPhrase,
    String signature,
    Function() success,
  ) {
    AuthService()
        .verifyLogin(
      zelid: zelid,
      loginPhrase: loginPhrase,
      signature: signature,
    )
        .then((value) {
      closeWebSocket();
      storeLoginDetails(context.read<AuthBloc>(), value);
      widget.showMessage('You have successfully logged in to Flux');
      success();
    }).catchError((error, stackTrace) {
      //PopupMessage.error(message: error.toString()).show(context);
    });
  }

  Widget _buildMessageField(BuildContext context) {
    LoginPhraseProvider provider = context.watch<LoginPhraseProvider>();
    messageTextController.text = provider.loginPhrase ?? 'Waiting for message';
    return TextFormField(
      controller: messageTextController,
      maxLines: 1,
      readOnly: true,
      decoration: textFieldDecoration(
        'Message',
        null,
        IconButton(
          icon: const Icon(Icons.content_copy),
          onPressed: () {
            Clipboard.setData(
              ClipboardData(text: messageTextController.text),
            ).then((value) {
              context.show(PopupMessageItem.success(message: 'Copied to clipboard'));
            });
          },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: 'Copy to Clipboard',
        ),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return TextFormField(
      controller: addressTextController,
      maxLines: 1,
      decoration: textFieldDecoration('Address', 'Insert ZelID or Bitcoin address', null),
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget _buildSignatureField(BuildContext context) {
    return TextFormField(
      controller: signatureTextController,
      maxLines: 1,
      decoration: textFieldDecoration('Signature', 'Insert Signature', null),
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  InputDecoration textFieldDecoration(String? label, String? hint, Widget? icon) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: textInputBorder,
      focusedBorder: textInputBorder,
      contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      icon: icon,
    );
  }

  InputBorder get textInputBorder => OutlineInputBorder(
        borderSide: BorderSide(width: 1.5, color: Theme.of(context).textTheme.bodyLarge!.color!),
        borderRadius: BorderRadius.circular(7),
      );

  @override
  String callbackValue() {
    return Uri.encodeFull('https://api.runonflux.io/id/verifylogin');
  }
}
