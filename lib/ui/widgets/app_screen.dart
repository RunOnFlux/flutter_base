import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher_string.dart';

abstract class AppScreen extends StatefulWidget {
  final AppScreenStateInfo? stateInfo;
  const AppScreen({
    Key? key,
    this.stateInfo,
  }) : super(key: key);
}

class ScreenInfo with ChangeNotifier {
  AppScreenStateInfo? get currentState => _currentState;

  set currentState(AppScreenStateInfo? state) {
    _currentState = state;
    notifyListeners();
  }

  AppScreenStateInfo? _currentState;
}

class AppScreenStateInfo {
  final bool? refreshEnabled;
  final int? refreshInterval;
  final bool? fabEnabled;
  final IconData? fabIcon;
  Function()? onRefresh;
  Function()? onFAB;

  AppScreenStateInfo({
    this.refreshEnabled,
    this.refreshInterval,
    this.fabEnabled,
    this.fabIcon,
  });
}

abstract class AppScreenState<T extends AppScreen> extends State<T> {
  @override
  void initState() {
    if (widget.stateInfo != null) {
      widget.stateInfo!.onFAB = onFAB;
      widget.stateInfo!.onRefresh = onRefresh;
      Future.microtask(() => GetIt.I<ScreenInfo>().currentState = widget.stateInfo!);
    }
    super.initState();
  }

  onFAB() {}

  onRefresh() {}

  Widget buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
      child: Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                try {
                  await launchUrlString('https://www.runonflux.io');
                } catch (err) {
                  debugPrint(err.toString());
                }
              },
              child: Text(
                'Footer Text',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: bootStrapValueBasedOnSize(
                    sizes: {
                      '': 10.0,
                      'sm': 10.0,
                      'md': 14.0,
                      'lg': 14.0,
                      'xl': 14.0,
                      'xxl': 14.0,
                    },
                    context: context,
                  ),
                ),
              ),
            ),
          ),
          /*Expanded(child: Container()),
          ChangeNotifierProvider.value(
            value: GetIt.I.get<NodeList>(),
            child: const FooterVersion(),
          ),*/
        ],
      ),
    );
  }
}

class FooterVersion extends StatelessWidget {
  const FooterVersion({super.key});

  @override
  Widget build(BuildContext context) {
    var text = '';
    return Text(
      text,
      style: TextStyle(
        fontSize: bootStrapValueBasedOnSize(
          sizes: {
            '': 10.0,
            'sm': 10.0,
            'md': 14.0,
            'lg': 14.0,
            'xl': 14.0,
            'xxl': 14.0,
          },
          context: context,
        ),
      ),
    );
  }
}
