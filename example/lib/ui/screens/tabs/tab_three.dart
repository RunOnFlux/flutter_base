import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';

class TabThreeScreen extends SimpleScreen {
  const TabThreeScreen({Key? key})
      : super(
          key: key,
          title: '',
        );

  @override
  State<TabThreeScreen> createState() => TabThreeScreenState();
}

class TabThreeScreenState extends SimpleScreenState<TabThreeScreen> {
  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(gutterSize: 0);
  }

  @override
  Widget buildChild(BuildContext context) {
    return BootstrapContainer(
      fluid: true,
      padding: mainPadding(),
      children: [
        BootstrapRow(
          children: [
            BootstrapCol(
              child: const TitledCard(
                child: Text('Three'),
              ),
            ),
          ],
        ),
        BootstrapRow(
          children: [
            BootstrapCol(
              fit: FlexFit.tight,
              child: const TitledCard(
                child: Text('Also Three'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
