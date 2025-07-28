import 'package:flutter/material.dart';
import 'package:flutter_base/ui/widgets/screen_info.dart';

class BaseRepository {
  final ValueNotifier<ScreenInfo> screenInfo = ValueNotifier<ScreenInfo>(ScreenInfo());
  final ValueNotifier<AppScreenRegistry> appScreenRegistry = ValueNotifier<AppScreenRegistry>(AppScreenRegistry());
}
