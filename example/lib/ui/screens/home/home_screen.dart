import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/utils/bootstrap.dart';
import 'package:flutter_base/ui/widgets/simple_screen.dart';
import 'package:flutter_base/ui/widgets/titled_card.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class HomeScreen extends SimpleScreen with GetItStatefulWidgetMixin {
  HomeScreen({Key? key})
      : super(
          key: key,
          title: 'Example',
        );

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends SimpleScreenState<HomeScreen> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(gutterSize: 20);
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
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-12 col-md-12 col-lg-7 col-xl-7',
              child: SizedBox(
                height: 300,
                child: UntitledCard(
                  padding: EdgeInsets.all(bootStrapValueBasedOnSize(sizes: {
                    '': 5.0,
                    'sm': 5.0,
                    'md': 10.0,
                    'lg': 10.0,
                    'xl': 10.0,
                    'xxl': 10.0,
                  }, context: context)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Image.asset(
                            'assets/images/header.9d3892c9.png',
                            fit: (constraints.maxWidth / constraints.maxHeight) < 1.7775
                                ? BoxFit.fitHeight
                                : BoxFit.fitWidth,
                            color: Colors.black45,
                            colorBlendMode: BlendMode.darken,
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 70, left: 30, right: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FluxOS',
                              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                            ),
                            ShaderMask(
                              blendMode: BlendMode.modulate,
                              shaderCallback: (size) => const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 62, 152, 252),
                                  Color.fromARGB(255, 163, 99, 241),
                                  Color.fromARGB(255, 231, 116, 145)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(
                                Rect.fromLTWH(0, 0, size.width, size.height),
                              ),
                              child: AutoSizeText(
                                'Example App',
                                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                      fontSize: 48,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                maxLines: 1,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Click Here',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12 col-sm-12 col-md-12 col-lg-5 col-xl-5',
              child: SizedBox(
                height: 300,
                child: TitledCard(
                  title: 'A TitledCard',
                  icon: Icons.access_alarm,
                  padding: EdgeInsets.all(
                    bootStrapValueBasedOnSize(sizes: {
                      '': 5.0,
                      'sm': 5.0,
                      'md': 10.0,
                      'lg': 10.0,
                      'xl': 10.0,
                      'xxl': 10.0,
                    }, context: context),
                  ),
                  child: Column(
                    children: [
                      Text('Some text'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        BootstrapRow(
          children: [
            BootstrapCol(
              fit: FlexFit.tight,
              sizes: 'col-12',
              child: SizedBox(
                height: 450,
                child: TitledCard(
                  title: 'A TitledCard with a back widget',
                  icon: Icons.backup_table,
                  padding: EdgeInsets.all(
                    bootStrapValueBasedOnSize(sizes: {
                      '': 5.0,
                      'sm': 5.0,
                      'md': 10.0,
                      'lg': 10.0,
                      'xl': 10.0,
                      'xxl': 10.0,
                    }, context: context),
                  ),
                  backChild: Column(
                    children: [
                      Text("Flipped Card"),
                    ],
                  ),
                  backToolTip: 'See you on the flip side',
                  backTitle: 'The flip side is here',
                  child: Column(
                    children: [
                      Text('Some text'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
