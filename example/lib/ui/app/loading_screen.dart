import 'package:flutter/material.dart';
import 'package:flutter_base/blocs/loading_bloc.dart';
import 'package:flutter_base/ui/theme/app_theme.dart';
import 'package:flutter_base/ui/theme/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';

class FlutterBaseLoadingScreen extends StatelessWidget {
  const FlutterBaseLoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppThemeImpl.getOptions(context).appBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 100,
              height: 100,
              child: LoadingIndicator(
                indicatorType: Indicator.lineScale,
                colors: kDefaultRainbowColors,
              ),
            ),
            BlocBuilder<LoadingBloc, LoadingState>(
              builder: (context, state) {
                if (state is AppLoadProgressState) {
                  return Text(state.message);
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
