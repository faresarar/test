import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../extensions.dart';
import '../../model/enums.dart';

class CustomPrimaryButton extends StatelessWidget {
  const CustomPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.buttonType = ButtonType.filled,
    this.leadingIcon,
    this.trailingIcon,

    //style
    this.fontSize,
    this.fontColor,
    this.color,
    this.disabledcolor,
    this.shadowColor,
    this.borderColor,

    //size
    this.maximumSize,
    this.minimumSize,
    this.fixedSize,
    this.elevation,

    //settings
    this.enabled = true,
    this.padding,
    this.contentPadding,
    this.borderRadius,
    this.addSpacer = false,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  final String label;
  final void Function()? onPressed;
  final ButtonType buttonType;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  //style
  final double? fontSize;
  final Color? fontColor;
  final Color? color;
  final Color? disabledcolor;
  final Color? shadowColor;
  final Color? borderColor;

  //size
  final Size? maximumSize;
  final Size? minimumSize;
  final Size? fixedSize;
  final double? elevation;

  //settings
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadiusGeometry? borderRadius;
  final bool addSpacer;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: isFilled ? elevation : 0,
          padding: contentPadding ??
              EdgeInsets.symmetric(
                vertical: 6.sp,
                horizontal: 16.sp,
              ),
          alignment: Alignment.center,
          maximumSize: maximumSize ?? Size(0.9.sw, 56.sp),
          minimumSize: minimumSize ?? Size(0.25.sw, 56.sp),
          fixedSize: fixedSize,
          backgroundColor: getBackgroundColor(context),
          disabledBackgroundColor: getDisabledBackgroundColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8.sp),
            side: isOutlined
                ? BorderSide(
                    color: getFontColor(context),
                    width: 2.sp,
                  )
                : BorderSide.none,
          ),
          shadowColor: isFilled ? shadowColor : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: [
            leadingIcon != null
                ? Padding(
                    padding: EdgeInsetsDirectional.only(end: 16.sp),
                    child: Icon(
                      leadingIcon!,
                      color: getFontColor(context),
                      size: 24.sp,
                    ),
                  )
                : isExpanded
                    ? 24.widthSp
                    : const SizedBox.shrink(),
            Text(
              label,
              style: context.button1style.copyWith(
                fontSize: fontSize,
                color: getFontColor(context),
              ),
            ),
            trailingIcon != null
                ? Padding(
                    padding: EdgeInsetsDirectional.only(start: 16.sp),
                    child: Icon(
                      trailingIcon!,
                      color: getFontColor(context),
                      size: 24.sp,
                    ),
                  )
                : isExpanded
                    ? 24.widthSp
                    : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  bool get isExpanded => addSpacer || mainAxisSize == MainAxisSize.max;

  bool get isFilled => buttonType == ButtonType.filled;
  bool get isOutlined => buttonType == ButtonType.outlined;
  bool get isText => buttonType == ButtonType.text;
  Color getBackgroundColor(BuildContext context) =>
      color ?? (isFilled ? context.primary : context.scaffoldBackgroundColor);

  Color getDisabledBackgroundColor(BuildContext context) =>
      disabledcolor ??
      (isFilled ? context.b4 : context.scaffoldBackgroundColor);

  Color getFontColor(BuildContext context) => isFilled
      ? (fontColor ?? Colors.white)
      : !enabled || onPressed == null
          ? context.b4
          : fontColor ?? context.primary;
}
