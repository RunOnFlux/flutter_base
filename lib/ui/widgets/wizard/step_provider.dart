import 'package:flutter/material.dart';

abstract class StepProvider {
  late String description;
  Widget getStepWidget();
}

abstract class FinalStepProvider extends StepProvider {
  late void Function() onFinish;
}
