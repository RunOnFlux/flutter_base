import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/app_screen.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:flutter_base/ui/widgets/tabbed_screen.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';

class TabTwoScreen extends TabContentScreen {
  TabTwoScreen({
    Key? key,
    required TabbedScreenState parent,
  }) : super(
          key: key,
          parent: parent,
          stateInfo: AppScreenStateInfo(),
        );

  @override
  State<TabTwoScreen> createState() => TabTwoScreenState();
}

class TabTwoScreenState extends TabContentScreenState<TabTwoScreen> {
  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(gutterSize: 0);
  }

  @override
  Widget buildChild(BuildContext context) {
    return BootstrapContainer(
      fluid: true,
      padding: context.mainPadding(),
      children: [
        BootstrapRow(
          children: [
            BootstrapCol(
              child: const TitledCard(
                child: Text('Two'),
              ),
            ),
          ],
        ),
        BootstrapRow(
          children: [
            BootstrapCol(
              fit: FlexFit.tight,
              child: const TitledCard(
                child: Text('Also Two'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
