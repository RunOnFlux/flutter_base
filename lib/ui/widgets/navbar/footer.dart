import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';

class SideBarFooter extends StatelessWidget {
  const SideBarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    AppConfig config = AppConfigScope.of(context)!;
    Widget? footer = config.buildMenuFooter(context);
    return footer ?? Container();

    /*return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildShareButton(context),
        const SizedBox(
          height: 20,
        ),
        _buildThemeController(context),
        const SizedBox(
          height: 12,
        ),
        _buildPoweredBy(context),
      ],
    );*/
  }

  /*Widget _buildPoweredBy(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.tr.poweredBy,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: context.watchTheme.data.colorScheme.onBackground)),
        const SizedBox(
          width: 5,
        ),
        const Logo(height: 20)
      ],
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return Column(children: [
      Text(context.tr.joinTheCommunity,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: context.watchTheme.data.colorScheme.onBackground,
          )),
      const SizedBox(
        height: 12,
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final share in SocialMediaShare.values)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: MaterialButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minWidth: 0,
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                  onPressed: () {
                    launchUrl(Uri.parse(share.url));
                  },
                  child: SvgPicture.asset(share.icon(context)),
                ))
        ],
      )
    ]);
  }

  Widget _buildThemeButton(BuildContext context, Brightness brightness, bool selected) {
    final themeState = context.watchTheme;
    Color? color;
    double elevation = 4;
    if (!selected) {
      color = Colors.transparent;
      elevation = 0;
    }
    final contentColor = selected ? themeState.data.primaryColor : themeState.data.disabledColor;
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        elevation: elevation,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: () {
            context.read<UserPreferencesCubit>().setBrightness(brightness);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              'assets/images/svg/${brightness == Brightness.light ? 'sun' : 'moon'}.svg',
              height: 24,
              colorFilter: ColorFilter.mode(contentColor, BlendMode.srcIn),
            ),
          ),
        ));
  }

  Widget _buildThemeController(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.watchTheme.headingRowColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: BlocBuilder<UserPreferencesCubit, UserPreference>(
        buildWhen: (previous, current) => previous.brightness != current.brightness,
        builder: (context, state) {
          return Row(mainAxisSize: MainAxisSize.min, children: [
            for (final brightness in ThemeManagerCubit.supportedBrightness)
              _buildThemeButton(context, brightness, state.brightness == brightness)
          ]);
        },
      ),
    );
  }*/
}
