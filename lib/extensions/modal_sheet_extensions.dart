import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:tinycolor2/tinycolor2.dart';

extension ModalSheet on BuildContext {
  showBottomSheet(
    WidgetBuilder builder, {
    bool useRootNavigator = true,
    bool enableDrag = true,
    Color? backgroundColor,
    bool isDismissible = true,
  }) {
    showModalBottomSheet(
      context: this,
      backgroundColor: backgroundColor ??
          (Theme.of(this).isLight
                  ? Theme.of(this).primaryColorLight.lighten()
                  : Theme.of(this).primaryColorDark.darken())
              .withOpacity(0.9),
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      useRootNavigator: useRootNavigator,
      builder: builder,
      isScrollControlled: true,
      constraints: const BoxConstraints(minWidth: 1200),
      //useSafeArea: true,
    );
  }
}
