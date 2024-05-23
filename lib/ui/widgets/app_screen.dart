import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher_string.dart';

abstract class AppContentScreen extends StatefulWidget {
  final AppScreenStateInfo stateInfo;
  const AppContentScreen({
    super.key,
    required this.stateInfo,
  });
}

abstract class AppScreenState<T extends AppContentScreen> extends State<T> {
  @override
  void initState() {
    super.initState();
    var state = GetIt.I<AppScreenRegistry>().get(widget.stateInfo.route);
    state ??= widget.stateInfo;
    state.onFAB = onFAB;
    state.onRefresh = onRefresh;
    GetIt.I<AppScreenRegistry>().set(widget.stateInfo.route, state);
    Future.microtask(() => GetIt.I<ScreenInfo>().currentState = state);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  onFAB() {}

  onRefresh() {}

  Widget titleHeader(BuildContext context) => Container();

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
                  fontFamily: 'Montserrat',
                  package: 'flutter_base',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension Paddings on BuildContext {
  EdgeInsets mainPadding() {
    return EdgeInsets.symmetric(
      horizontal: bootStrapValueBasedOnSize(
        sizes: {
          '': 5.0,
          'sm': 12.0,
          'md': 20.0,
          'lg': 25.0,
          'xl': 25.0,
          'xxl': 25.0,
        },
        context: this,
      ),
      vertical: 10.0,
    );
  }
}
