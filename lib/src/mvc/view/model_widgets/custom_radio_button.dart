import 'package:flutter/material.dart';

import '../../../extensions.dart';

class CustomRadioButton<T> extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  final T value;
  final T groupValue;
  final String label;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: context.primary,
      dense: true,
      title: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.h4b1,
      ),
    );
  }
}
