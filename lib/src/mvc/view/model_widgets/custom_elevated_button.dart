import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../extensions.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.color,
    this.disabledcolor,
    this.fontSize,
    this.fixedSize,
    this.elevation,
    this.fontColor,
    this.shadowColor,
    this.borderColor,
    this.maximumSize,
    this.minimumSize,
    this.padding,
    this.borderRadius,
    this.enabled = true,
  });

  final String label;
  final IconData? icon;
  final void Function()? onPressed;
  final Color? color;
  final Color? disabledcolor;
  final Size? maximumSize;
  final Size? minimumSize;
  final Size? fixedSize;
  final double? fontSize;
  final double? elevation;
  final Color? fontColor;
  final Color? shadowColor;
  final Color? borderColor;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          padding: EdgeInsets.symmetric(
            vertical: 6.sp,
            horizontal: 12.sp,
          ),
          alignment: Alignment.center,
          maximumSize: maximumSize,
          minimumSize: minimumSize ?? Size(0.25.sw, 54.sp),
          fixedSize: fixedSize ?? Size(0.9.sw, 54.sp),
          backgroundColor: enabled && onPressed != null
              ? color ?? context.primary
              : disabledcolor ?? context.b5,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(24.sp),
            side: borderColor == null
                ? BorderSide.none
                : BorderSide(
                    color: borderColor!,
                    width: 1.5.sp,
                  ),
          ),
          shadowColor: shadowColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon!,
                color: enabled && onPressed != null
                    ? (fontColor ?? Colors.white)
                    : Colors.grey,
                size: 26.sp,
              ),
              SizedBox(width: 20.sp),
            ],
            Text(
              label,
              style: context.h3b1.copyWith(
                fontSize: fontSize,
                color: enabled && onPressed != null
                    ? (fontColor ?? Colors.white)
                    : Colors.grey,
              ),
            ),
            if (icon != null) SizedBox(width: 46.sp),
          ],
        ),
      ),
    );
  }
}
