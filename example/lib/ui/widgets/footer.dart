import 'package:flutter/material.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/widgets/logo.dart';
import 'package:flutter_base_example/utils/social_media.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBarFooter extends StatelessWidget {
  const SideBarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Column(
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
      ),
    );
  }

  Widget _buildPoweredBy(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Powered by',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onBackground)),
        const SizedBox(
          width: 5,
        ),
        const Logo(height: 20)
      ],
    );
  }

  Widget _buildShareButton(BuildContext context) {
    return Column(children: [
      Text('Join the Community',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onBackground,
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
    final themeState = Theme.of(context);
    Color? color;
    double elevation = 4;
    if (!selected) {
      color = Colors.transparent;
      elevation = 0;
    }
    final contentColor = selected ? themeState.primaryColor : themeState.disabledColor;
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        elevation: elevation,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: () {
            ThemeProvider.controllerOf(context).setTheme(
                brightness == Brightness.dark ? GetIt.I<AppThemeImpl>().dark.id : GetIt.I<AppThemeImpl>().light.id);
            //context.read<UserPreferencesCubit>().setBrightness(brightness);
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
        color: Theme.of(context).headingRowColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        for (final brightness in Brightness.values)
          _buildThemeButton(context, brightness, Theme.of(context).brightness == brightness)
      ]),
    );
  }
}

/*class NewVersionIndicator extends StatelessWidget {
  const NewVersionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalWorkerSystemCubit, LocalWorkerSystemState>(buildWhen: (previous, current) {
      return previous.hasNewVersion != current.hasNewVersion;
    }, builder: (context, state) {
      final hasNewVersion = state.hasNewVersion;
      return SimpleContainer(
              showBorder: true,
              borderRadius: 12,
              backgroundColor: context.watchTheme.data.cardColor,
              margin: const EdgeInsets.only(bottom: 8, top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Flexible(
                        child: Text(
                      context.tr.setupWizardUpdateNewUpdateAvailable,
                      softWrap: false,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                    SvgPicture.asset('assets/images/svg/arrow_fat_lines_up.svg',
                        width: 16, colorFilter: const ColorFilter.mode(Color(0xFF009521), BlendMode.srcIn), height: 16)
                  ]),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultTextButton.cancel(
                        minHeight: 30,
                        borderRadius: 8,
                        fontSize: 10,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        text: context.tr.skip,
                        onPressed: () {
                          LocalWorkerSystemCubit.instance.skipCurrentUpdate();
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      DefaultTextButton(
                          minHeight: 30,
                          borderRadius: 8,
                          fontSize: 10,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                          text: context.tr.updateNow,
                          onPressed: () {
                            const UpdatePopupScreen.local().show(context);
                          })
                    ],
                  )
                ],
              ))
          .animate(target: hasNewVersion ? 1 : 0)
          .show(maintain: false)
          .then(delay: 250.ms)
          .slideY(end: 0, begin: 1, duration: 300.ms)
          .fadeIn(duration: 200.ms);
    });
  }
}*/
