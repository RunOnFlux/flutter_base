import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'assets_path.dart';
import 'snackbar_type.dart';

class SnackbarContent extends StatelessWidget {
  /// `IMPORTANT NOTE` for SnackBar properties before putting this in `content`
  /// backgroundColor: Colors.transparent
  /// behavior: SnackBarBehavior.floating
  /// elevation: 0.0
  /// /// `IMPORTANT NOTE` for MaterialBanner properties before putting this in `content`
  /// backgroundColor: Colors.transparent
  /// forceActionsBelow: true,
  /// elevation: 0.0
  /// [inMaterialBanner = true]
  /// title is the header String that will show on top
  final String title;

  /// message String is the body message which shows only 2 lines at max
  final String message;

  /// `optional` color of the SnackBar/MaterialBanner body
  final Color? color;

  /// contentType will reflect the overall theme of SnackBar/MaterialBanner: failure, success, help, warning
  final SnackbarType contentType;

  /// if you want to use this in materialBanner
  final bool inMaterialBanner;

  const SnackbarContent({
    Key? key,
    this.color,
    required this.title,
    required this.message,
    required this.contentType,
    this.inMaterialBanner = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // screen dimensions
    bool isMobile = size.width <= 768;
    bool isTablet = size.width > 768 && size.width <= 992;
    bool isDesktop = size.width >= 992;

    /// For reflecting different color shades in the SnackBar
    final hsl = HSLColor.fromColor(color ?? contentType.color!);
    final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

    return Row(
      children: [
        !isMobile
            ? const Spacer()
            : SizedBox(
                width: size.width * 0.01,
              ),
        Expanded(
          flex: !isDesktop ? 8 : 4,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              /// SnackBar Body
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: isTablet ? size.width * 0.1 : 0,
                ),
                decoration: BoxDecoration(
                  color: color ?? contentType.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Stack(
                    children: [
                      /// other SVGs in body
                      Positioned(
                        bottom: -10,
                        left: -10,
                        //left: isTablet ? size.width * 0.1 : 0,
                        child: SvgPicture.asset(
                          AssetsPath.logo,
                          height: 70,
                          width: 70,
                          color: hslDark.toColor(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: isMobile ? 15 : 25,
                        ),
                        child: Row(
                          children: [
                            const Spacer(),
                            Expanded(
                              flex: isMobile ? 8 : 25,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      /// `title` parameter
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          title,
                                          style: Theme.of(context).textTheme.headlineLarge,
                                          /*style: TextStyle(
                                                fontSize:
                                                    isTablet || isDesktop ? size.height * 0.03 : size.height * 0.025,
                                                color: Colors.white,
                                              ),*/
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                                          if (inMaterialBanner) {
                                            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                          } else {
                                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          AssetsPath.failure,
                                          height: size.height * 0.022,
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// `message` body text parameter
                                  Text(
                                    message,
                                    /*style: TextStyle(
                                          fontSize: size.height * 0.016,
                                          color: Colors.white,
                                        ),*/
                                    style: Theme.of(context).textTheme.headlineMedium,
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: -25,
                left: isTablet ? size.width * 0.125 : size.width * 0.01,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      AssetsPath.back,
                      height: 60,
                      color: hslDark.toColor(),
                    ),
                    Positioned(
                      top: 15,
                      child: SvgPicture.asset(
                        assetSVG(contentType),
                        height: 25,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        !isMobile
            ? const Spacer()
            : SizedBox(
                width: size.width * 0.01,
              ),
      ],
    );
  }

  /// Reflecting proper icon based on the contentType
  String assetSVG(SnackbarType contentType) {
    if (contentType == SnackbarType.failure) {
      /// failure will show `CROSS`
      return AssetsPath.failure;
    } else if (contentType == SnackbarType.success) {
      /// success will show `CHECK`
      return AssetsPath.success;
    } else if (contentType == SnackbarType.warning) {
      /// warning will show `EXCLAMATION`
      return AssetsPath.warning;
    } else if (contentType == SnackbarType.help) {
      /// help will show `QUESTION MARK`
      return AssetsPath.help;
    } else {
      return AssetsPath.failure;
    }
  }
}
