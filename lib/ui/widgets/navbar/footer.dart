import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/config/app_config.dart';
import 'package:flutter_base/ui/app/scope/app_config_scope.dart';

class SideBarFooter extends StatelessWidget {
  const SideBarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfigScope.of(context)!;
    Widget? footer = config.buildMenuFooter(context);
    return footer ?? Container();
  }
}
