import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/app_screen.dart';
import 'package:flutter_base/ui/widgets/floating_action_menu.dart';
import 'package:flutter_base/ui/widgets/popup/popup_message_item.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';
import 'package:flutter_base/ui/widgets/tabbed_screen.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';

class TabOneScreen extends TabContentScreen {
  TabOneScreen({
    Key? key,
    required TabbedScreenState parent,
  }) : super(
          key: key,
          parent: parent,
          stateInfo: AppScreenStateInfo(
            fabIcon: Icons.upload_file_outlined,
          ),
        );

  @override
  State<TabOneScreen> createState() => TabOneScreenState();
}

class TabOneScreenState extends TabContentScreenState<TabOneScreen> {
  @override
  void initState() {
    widget.stateInfo.items = [
      FloatingMenuItem(
        title: 'Menu Item 1',
        icon: Icons.ac_unit_outlined,
        onPress: () {
          PopupMessageItem.success(message: 'Menu Item 1 was clicked!!').show(context);
        },
      ),
      FloatingMenuItem(
        title: 'Menu Item 2',
        icon: Icons.back_hand_outlined,
      ),
      FloatingMenuItem(
        title: 'Menu Item 3',
        icon: Icons.cabin_outlined,
      ),
    ];
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
                child: Text('One'),
              ),
            ),
          ],
        ),
        BootstrapRow(
          children: [
            BootstrapCol(
              fit: FlexFit.tight,
              child: const TitledCard(
                child: Text('Also One'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
