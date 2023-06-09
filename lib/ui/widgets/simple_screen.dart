import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/app_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';

abstract class SimpleScreen extends AppScreen {
  final String title;
  const SimpleScreen({
    Key? key,
    required this.title,
    super.stateInfo,
  }) : super(key: key);
}

abstract class SimpleScreenState<T extends SimpleScreen> extends AppScreenState<T>
    with AutomaticKeepAliveClientMixin<T> {
  Widget buildChild(BuildContext context);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: ScrollController(),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: buildScreen(context),
        ),
        /*SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              Expanded(child: Container()),
              buildFooter(context),
            ],
          ),
        ),*/
      ],
      //
    );
  }

  EdgeInsets mainPadding() {
    return EdgeInsets.all(bootStrapValueBasedOnSize(sizes: {
      '': 5.0,
      'sm': 12.0,
      'md': 20.0,
      'lg': 25.0,
      'xl': 25.0,
      'xxl': 25.0,
    }, context: context));
  }

  Widget buildScreen(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildChild(context),
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: LoadingIndicator(indicatorType: Indicator.circleStrokeSpin),
      ),
    );
  }
}
