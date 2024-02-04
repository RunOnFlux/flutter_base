import 'package:flutter/material.dart';
import 'package:flutter_base/ui/widgets/app_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';

abstract class SimpleScreen extends AppContentScreen {
  const SimpleScreen({
    super.key,
    required super.stateInfo,
  });
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

  Widget buildScreen(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildChild(context),
      ],
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
