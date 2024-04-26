import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../extensions.dart';
import '../../model/models_ui.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.button,
    this.fontSize,
    this.enabled = true,
  });

  final ModelTextButton button;
  final double? fontSize;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    var textColor = enabled && button.onPressed != null
        ? ((button.style ?? context.button2style).color)
        : context.b3;
    var text = Text(
      button.label,
      style: context.button2style.copyWith(
        color: textColor,
      ),
    );
    if (button.icon == null) {
      return TextButton(
        onPressed: enabled ? button.onPressed : null,
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          elevation: 0,
          backgroundColor: context.scaffoldBackgroundColor,
          shadowColor: Colors.transparent,
          foregroundColor: context.scaffoldBackgroundColor,
        ),
        child: text,
      );
    }
    return TextButton.icon(
      onPressed: button.onPressed,
      icon: Icon(
        button.icon,
        color: textColor,
        size: 24.sp,
      ),
      label: text,
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
      ),
    );
  }
}
