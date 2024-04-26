import 'package:flutter/material.dart';

/// a value notifier of type String
class NotifierString extends ValueNotifier<String> {
  NotifierString(String value) : super(value);

  /// update with [value] and notify listeners
  void setValue(String value) {
    this.value = value;
    notifyListeners();
  }
}
