import 'package:flutter/material.dart';

class MyAppShowCaseKeys {
  static GlobalKey hideMenu = GlobalKey();
  static GlobalKey community = GlobalKey();
  static GlobalKey lightMode = GlobalKey();
  static GlobalKey homeFAB = GlobalKey();
  static GlobalKey homeToggle = GlobalKey();
  static GlobalKey menuItem = GlobalKey();
  static GlobalKey sideMenu = GlobalKey();

  void resetMenuKeys() {
    menuItem = GlobalKey();
  }
}
