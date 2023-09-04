import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_base/ui/app/app_screen.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/routes/route.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/navbar/footer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'menu.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerScope = AppDrawerScope.of(context);
    final isCollapsed = drawerScope?.isCollapsed ?? true;
    final isSmallScreen = drawerScope?.isSmallScreen ?? false;
    final theme = Theme.of(context);

    return Drawer(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: !isCollapsed && isSmallScreen ? theme.backgroundGradient : null),
              child: Drawer(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(children: <Widget>[
                    const SideBarHeader(),
                    Expanded(child: SideBarMenuWidget()),
                    const SizedBox(
                      height: 24,
                    ),
                    const SideBarFooter(),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CollapsedSidebar extends StatelessWidget with GetItMixin {
  CollapsedSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StatefulNavigationShell>();
    final currentIndex = state.currentIndex;

    PrivilegeLevel? privilege;
    if (GetIt.instance.isRegistered<LoginState>()) {
      privilege = watchOnly((LoginState state) => state.privilege);
    }

    List<AbstractRoute> routes = AppRouterScope.of(context).buildRoutes();
    List<AbstractRoute> active = routes.where((element) => element.active ?? true).toList();
    List<AbstractRoute> inactive = routes.where((element) => !(element.active ?? true)).toList();
    List allRoutes = [active, inactive];

    return Container(
      width: 64,
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 23),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          const SideBarButton(),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final items = allRoutes[index];
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final selected = false; //currentIndex == item.index;
                      return SideBarMenuItem(
                              selected: selected,
                              enabled: item.active,
                              index: index,
                              iconAsset: item.iconAsset,
                              onTap: defaultMenuIconTap)
                          .build(context);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: allRoutes.length),
          )
        ],
      ),
    );
  }
}

class SideBarButton extends StatelessWidget {
  const SideBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appScope = AppDrawerScope.of(context);
    final isCollapsed = appScope?.isCollapsed ?? true;
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () {
        if (isCollapsed) {
          appScope?.openDrawer();
        } else {
          appScope?.closeDrawer();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SvgPicture.asset(
          'assets/images/svg/sidebar_collapse_icon.svg',
          height: 10,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onBackground,
            BlendMode.srcIn,
          ),
        )
            .animate(target: isCollapsed ? 0 : 1)
            .swap(builder: (context, _) => const Icon(Icons.arrow_back))
            .rotate(begin: 0, end: 360),
      ),
    );
  }
}

class SideBarHeader extends StatelessWidget {
  const SideBarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfigScope.of(context)!;
    Widget? header = config.buildMenuHeader(context);
    return header ?? Container();
  }
}

/*class SideBarStatus extends StatelessWidget {
  const SideBarStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalWorkerSystemCubit, LocalWorkerSystemState>(buildWhen: (previous, current) {
      return previous.applicationOnline != current.applicationOnline || previous.serviceOnline != current.serviceOnline;
    }, builder: (context, state) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Flexible(
            child: ActivatedText(text: context.tr.applicationOnline, activated: state.applicationOnline),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: ActivatedText(text: context.tr.servicesOnline, activated: state.serviceOnline),
          ),
        ]),
      );
    });
  }
}
*/
