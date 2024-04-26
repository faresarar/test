import 'package:flutter/material.dart';

import '../../../extensions.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: context.pop,
      icon: Icon(context.backButtonIcon),
    );
  }
}
