import 'package:flutter/material.dart';

/// a value notifier of type bool
class NotifierInt extends ValueNotifier<int> {
  NotifierInt(int value) : super(value);

  /// update with [value] and notify listeners
  void setValue(int value) {
    this.value = value;
    notifyListeners();
  }
}
