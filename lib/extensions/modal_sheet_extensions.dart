import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tinycolor2/tinycolor2.dart';

extension ModalSheet on BuildContext {
  showBottomSheet(
    WidgetBuilder builder, {
    bool useRootNavigator = true,
    bool enableDrag = true,
  }) {
    showMaterialModalBottomSheet(
      context: this,
      backgroundColor: Theme.of(this).canvasColor.lighten().withOpacity(0.9),
      enableDrag: enableDrag,
      isDismissible: true,
      useRootNavigator: useRootNavigator,
      builder: builder,
    );
  }
}
