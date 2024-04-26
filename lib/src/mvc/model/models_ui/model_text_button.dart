import 'dart:async';

import 'package:flutter/material.dart';

class ModelTextButton<T> {
  final String label;
  final TextStyle? style;
  final Color? color;
  final IconData? icon;
  final FutureOr<T> Function()? onPressed;

  ModelTextButton({
    required this.label,
    this.style,
    this.color,
    this.icon,
    this.onPressed,
  });
}
