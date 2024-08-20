import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_base/api/model/id/id_model.dart';
import 'package:flutter_base/auth/auth_bloc.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/dialogs/dialog_sizes.dart';
import 'package:flutter_base/ui/widgets/dialogs/login/first_card.dart';
import 'package:flutter_base/ui/widgets/dialogs/login/login_phrase_provider.dart';
import 'package:flutter_base/ui/widgets/dialogs/login/second_card.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message.dart';
import 'package:flutter_base/utils/zelcore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http_query_string/http_query_string.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LoginDialog extends StatefulWidget {
  final Function(String) showMessage;

  const LoginDialog({
    super.key,
    required this.showMessage,
  });

  @override
  LoginDialogState createState() => LoginDialogState();
}

class LoginDialogState extends State<LoginDialog> with DialogSizes, TickerProviderStateMixin, ZelCoreWebSockets {
  double imageSize = 100;

  bool isNext = false;

  late AnimationController _controller;
  late Animation _animation;

  late AnimationController _controllerRotate;
  late Animation _animationRotate;

  double left0 = 0;
  double left1 = 700;

  final LoginPhraseProvider loginPhraseProvider = LoginPhraseProvider();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controllerRotate = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animationRotate = CurvedAnimation(parent: _controllerRotate, curve: Curves.fastOutSlowIn);
    refreshLoginPhrase();
  }

  void refreshLoginPhrase() {
    final authBloc = context.read<AuthBloc>();
    loginPhraseProvider.fetchData().then((_) {
      //debugPrint(loginPhraseProvider.nodeIP);
      log('fetched login phrase ${loginPhraseProvider.loginPhrase}');
      initiateLoginWS(
        loginPhraseProvider.loginPhrase!,
        () {
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            widget.showMessage('You have successfully logged in to FluxCloud');
          }
        },
        /*() {
          log('refreshLoginPhrase close');
          if (mounted) {
            refreshLoginPhrase();
          }
        },*/
        () => null,
        (error) => null,
        authBloc,
      );
    });
  }

  late StateSetter stateSetter;

  @override
  Widget build(BuildContext context) {
    final width = bootStrapValueBasedOnSize(
      sizes: {
        'xxl': 900.0,
        'xl': 700.0,
        'lg': 600.0,
        'md': 500.0,
        'sm': 400.0,
        '': 400.0,
      },
      context: context,
    );
    final authBloc = context.read<AuthBloc>();

    return PopupMessageWidget(
      key: GlobalKey(),
      child: ChangeNotifierProvider.value(
        value: loginPhraseProvider,
        child: StatefulBuilder(builder: (context, StateSetter setState) {
          stateSetter = setState;
          return Center(
            child: SizedBox(
              width: width,
              height: 500,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor.withAlpha(192),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: const Offset(5, 5),
                          color: Theme.of(context).cardTheme.shadowColor!,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 110,
                            width: 110,
                            child: Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                width: imageSize,
                                height: imageSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: const Offset(3, 3),
                                      color: Theme.of(context).cardTheme.shadowColor!,
                                    ),
                                  ],
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Consumer<LoginPhraseProvider>(
                                  builder: (_, loginProvider, __) => InkWell(
                                    onTap: () async {
                                      loginPhraseProvider.fetchData().then(
                                        (value) {
                                          if (value != null) {
                                            openZelCore(
                                              //loginProvider.nodeIP!,
                                              value,
                                              () {
                                                if (mounted && Navigator.of(context).canPop()) {
                                                  Navigator.of(context).pop();
                                                  widget.showMessage('You have successfully logged in to FluxCloud');
                                                }
                                              },
                                              authBloc,
                                            );
                                          } else {
                                            // something has gone wrong, or the data is not available yet
                                          }
                                        },
                                      );
                                    },
                                    onHover: (hover) {
                                      setState(() {
                                        imageSize = hover ? 105 : 100;
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/svg/fluxid.svg',
                                      fit: BoxFit.fill,
                                      package: 'flutter_base',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedBuilder(
                              animation: _animation,
                              builder: (BuildContext context, Widget? child) {
                                double _width = width * 2;
                                double _leftFront = 0;
                                double _leftBack = 0;
                                if (isNext) {
                                  _leftFront = -(_animation.value) * _width;
                                  _leftBack = (1.0 - _animation.value) * _width;
                                } else {
                                  _leftFront = (_animation.value) * _width;
                                  _leftBack = -(1.0 - _animation.value) * _width;
                                }

                                return AnimatedBuilder(
                                  animation: _animationRotate,
                                  builder: (BuildContext context, Widget? child) {
                                    double value = isNext ? _animationRotate.value : -(_animationRotate.value);
                                    Matrix4 transform = _pmat(1.0).scaled(1.0, 1.0 - value * 0.01, 1.0)
                                      ..rotateX(0.0)
                                      ..rotateY(12 * math.pi / 180 * value)
                                      ..rotateZ(0);
                                    return Stack(
                                      children: [
                                        FirstCard(
                                          left: _leftFront,
                                          width: width,
                                          transform: transform,
                                          next: next,
                                          showMessage: widget.showMessage,
                                        ),
                                        SecondCard(
                                          left: _leftBack,
                                          width: width,
                                          transform: transform,
                                          prev: prev,
                                          setState: setState,
                                          showMessage: widget.showMessage,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Tooltip(
                      message: 'Close',
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon: const Icon(Icons.close_outlined, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            //(GetIt.I<LoginState>() as FluxCloudLoginState).refreshRouting = false;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Matrix4 _pmat(num pv) {
    return Matrix4(
      1.0,
      0.0,
      0.0,
      0.0,
      //
      0.0,
      1.0,
      0.0,
      0.0,
      //
      0.0,
      0.0,
      1.0,
      pv * 0.001,
      //
      0.0,
      0.0,
      0.0,
      1.0,
    );
  }

  void next() {
    if (!_controller.isAnimating) {
      isNext = true;
      _controllerRotate.forward(from: 0).then((_) => _controllerRotate.reverse());
      _controller.forward(from: 0);
    }
  }

  void prev() {
    if (!_controller.isAnimating) {
      isNext = false;
      _controllerRotate.forward(from: 0).then((_) => _controllerRotate.reverse());
      _controller.reverse(from: 1);
    }
  }
}

mixin ZelCoreWebSockets {
  WebSocketChannel? channel;

  initiateLoginWS(
    String loginPhrase,
    Function() success,
    Function()? onClose,
    Function(String error)? onError,
    AuthBloc authBloc,
  ) {
    closeWebSocket();
    //var backendUrl = nodeIP;
    //var backendUrl = 'http${Constants.httpLogin ? '' : 's'}://$nodeIP';
    //backendUrl = backendUrl.replaceAll('https://', 'wss://');
    //backendUrl = backendUrl.replaceAll('http://', 'ws://');
    const backendUrl = 'wss://api.runonflux.io';
    final wsuri = '$backendUrl/ws/id/$loginPhrase';
    channel = WebSocketChannel.connect(Uri.parse(wsuri));
    channel!.stream.listen((message) async {
      debugPrint(message.toString());
      var qs = Decoder();
      var decoded = qs.convert(message.toString());
      debugPrint(decoded.toString());
      if (decoded.containsKey('status')) {
        if (decoded['status'] == 'success') {
          var login = FluxLogin.fromJson(decoded);
          storeLoginDetails(authBloc, login);
          success();
        } else {
          if (onError != null) onError(decoded['data']['message'] ?? 'Unknown Error');
        }
      } else {
        if (onError != null) onError(decoded['data']['message'] ?? 'Unknown Error');
      }
    }, onDone: () {
      debugPrint('onDone');
      debugPrint('${channel!.closeCode} ${channel!.closeReason}');
      if (channel!.closeCode != 1000 && onClose != null) {
        onClose();
      }
    }, onError: (e) {
      debugPrint('onError $e');
      if (onError != null) {
        onError(e.toString());
      }
    });
  }

  void closeWebSocket() {
    if (channel != null) {
      channel!.sink.close();
    }
  }

  void openZelCore(
    String loginPhrase,
    Function() success,
    AuthBloc authBloc,
  ) {
    ZelCore.openZelCoreSign(loginPhrase, callbackValue()).then((value) {
      initiateLoginWS(
        loginPhrase,
        success,
        null,
        null,
        authBloc,
      );
    });
  }

  String callbackValue() {
    return Uri.encodeFull('https://api.runonflux.io/id/verifylogin');
  }

  void storeLoginDetails(AuthBloc authBloc, FluxLogin fluxLogin) {
    authBloc.add(UpdateFluxLoginEvent(fluxLogin));
  }
}
