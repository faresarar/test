import 'package:flutter/material.dart';

/// a value notifier of type bool
class NotifierBool extends ValueNotifier<bool> {
  NotifierBool(bool value) : super(value);

  /// update with [value] and notify listeners
  void setValue(bool value) {
    this.value = value;
    notifyListeners();
  }
}
