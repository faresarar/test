import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../tools.dart';
import '../../model/models_ui.dart';
import '../model_widgets.dart';

/// shows an bottomsheet adaptive to its content, will take full screen
/// or only part of the screen
class AdaptiveBottomSheet extends StatelessWidget {
  const AdaptiveBottomSheet({
    super.key,
    required this.children,
    required this.continueButton,
    required this.cancelButton,
    required this.mainAxisSize,
    this.bottomPadding,
    this.padding,
  });

  /// continue button
  final ModelTextButton? continueButton;

  /// cancel or no button. if `null`, don't show it
  final ModelTextButton? cancelButton;

  /// content of the bottom sheet
  final List<Widget> children;

  /// defines the size of the bottom sheet, `MainAxisSize.max` to take full screen,
  /// or `MainAxisSize.min` to take only part of the screen
  final MainAxisSize mainAxisSize;

  ///Padding to action buttons
  final double? bottomPadding;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints.loose(
          Size(
            1.sw,
            1.sh - Paddings.viewPadding.top,
          ),
        ),
        padding: (padding ?? EdgeInsets.symmetric(horizontal: 35.w)).copyWith(
          top: 5.h,
          bottom: context.isKeyboardVisible
              ? 0
              : min(30.h, 15.h + Paddings.viewPadding.bottom),
        ),
        margin: EdgeInsets.only(
          bottom: context.viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.sp),
          ),
        ),
        child: Column(
          mainAxisSize:
              context.isKeyboardVisible ? MainAxisSize.max : mainAxisSize,
          children: [
            Container(
              height: 5.sp,
              width: 150.sp,
              decoration: BoxDecoration(
                color: context.b2,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            10.heightSp,
            ...children,
            if (continueButton != null || cancelButton != null)
              Padding(
                padding: EdgeInsets.only(top: bottomPadding ?? 40.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (cancelButton != null)
                      Expanded(
                        child: CustomTextButton(
                          button: cancelButton!,
                        ),
                      ),
                    if (cancelButton != null && continueButton != null)
                      SizedBox(
                        height: 20.sp,
                        child: VerticalDivider(
                          color: context.b4,
                          width: 1.sp,
                          thickness: 1.sp,
                        ),
                      ),
                    if (continueButton != null)
                      Expanded(
                        child: CustomTextButton(
                          button: continueButton!,
                        ),
                      ),
                  ],
                ),
              ),
            20.heightSp,
          ],
        ),
      ),
    );
  }
}
