import 'package:flutter/widgets.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class SkipFocusNode extends FocusNode {
  @override
  bool get skipTraversal => true;
}
