import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/ui/app/minimal_app.dart';
import 'package:flutter_base/ui/widgets/background_theme_builder.dart';
import 'package:flutter_base/utils/config.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.child});
  final Widget child;

  static Size? _currentDeviceSize;
  static Size get currentDeviceSize {
    assert(_currentDeviceSize != null);
    return _currentDeviceSize!;
  }

  static ResponsiveBreakpointsData? _currentBreakpoints;
  static ResponsiveBreakpointsData get currentBreakpoints {
    assert(_currentBreakpoints != null);
    return _currentBreakpoints!;
  }

  static const double smallScreenWidth = 1000;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints.builder(
        debugLog: kDebugMode,
        child: Builder(builder: (context) {
          _currentBreakpoints = ResponsiveBreakpoints.of(context);
          _currentDeviceSize = MediaQuery.of(context).size;
          final child = BackgroundThemeBuilder(this.child);

          if (_currentDeviceSize!.width > smallScreenWidth) {
            return child;
          } else {
            AppConfig config = AppConfigScope.of(context)!;
            if (config.smallScreenScroll) {
              return _SmallScreenWrapper(child: child);
            } else {
              return child;
            }
          }
        }),
        breakpoints: [
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ]);
  }
}

extension ResponsiveNumExtension on num {
  Size get _size => ResponsiveBuilder.currentDeviceSize;

  double get h => this * _size.height / kDesignSize.height;
  double get w => this * _size.width / kDesignSize.width;
  double get sh => this * _size.height;
  double get sw => this * _size.width;
  double get sp => this * _size.shortestSide / kDesignSize.shortestSide;
  double get r => this * _size.width / kDesignSize.width;

  bool isSmallWidth([num offset = ResponsiveBuilder.smallScreenWidth]) => _size.width < offset;

  bool isSmallHeight([num offset = 400]) => _size.height < offset;
}

extension ResponsiveBreakpointsDataExtension on ResponsiveBreakpointsData {
  double get shortestSide => screenWidth < screenHeight ? screenWidth : screenHeight;
}

extension BuildContextExtension on BuildContext {
  bool isSmallHeight([num offset = 400]) => MediaQuery.of(this).size.height < offset;

  bool isSmallWidth([num offset = ResponsiveBuilder.smallScreenWidth]) => MediaQuery.of(this).size.width < offset;
}

class _SmallScreenWrapper extends StatefulWidget {
  const _SmallScreenWrapper({required this.child});
  final Widget child;

  @override
  State<_SmallScreenWrapper> createState() => __SmallScreenWrapperState();
}

class __SmallScreenWrapperState extends State<_SmallScreenWrapper> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          controller: _scrollController2,
          child: Scrollbar(
            interactive: true,
            scrollbarOrientation: ScrollbarOrientation.bottom,
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            child: Scrollbar(
                interactive: true,
                scrollbarOrientation: ScrollbarOrientation.right,
                controller: _scrollController2,
                thumbVisibility: true,
                trackVisibility: true,
                child: SizedBox.fromSize(
                    size: kDesignSize, child: ClipRect(clipBehavior: Clip.hardEdge, child: widget.child))),
          ),
        ),
      ),
    );
  }
}
