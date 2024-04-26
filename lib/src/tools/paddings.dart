import 'package:flutter/material.dart';

class Paddings {
  static late final EdgeInsets viewPadding;
  static bool initialized = false;
  static late final EdgeInsets viewInsets;
  static late final EdgeInsets padding;

  static void init(BuildContext context) {
    if (initialized) return;
    viewPadding = MediaQuery.of(context).viewPadding;
    viewInsets = MediaQuery.of(context).viewInsets;
    padding = MediaQuery.of(context).padding;
    initialized = true;
  }
}
