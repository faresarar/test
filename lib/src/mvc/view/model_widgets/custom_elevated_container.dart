import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../tools.dart';

class CustomElevatedContainer extends StatelessWidget {
  const CustomElevatedContainer({
    super.key,
    required this.textDirection,
    required this.imageAsset,
    this.children,
    required this.onPressed,
    this.title,
    this.subtitle,
    this.hint,
    this.backgroundColor,
    this.imageAlignment = Alignment.center,
  }) : assert((title != null && subtitle != null) || children != null);

  final String imageAsset;
  final TextDirection textDirection;
  final String? title;
  final String? subtitle;
  final String? hint;
  final List<Widget>? children;
  final void Function() onPressed;
  final Color? backgroundColor;
  final AlignmentGeometry imageAlignment;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onPressed,
      child: Container(
        height: 145.sp,
        margin: EdgeInsets.symmetric(horizontal: 20.w).copyWith(bottom: 24.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: backgroundColor ?? context.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.sp),
          boxShadow: [
            BoxShadow(
              color: context.b2.withOpacity(0.15),
              offset: const Offset(0.0, 5.0),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Flex(
          direction: Axis.horizontal,
          textDirection: textDirection,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imageAsset,
              height: double.infinity,
              width: 115.sp,
              alignment: imageAlignment,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children ??
                    [
                      Text(
                        title!,
                        style: context.h3b1,
                      ),
                      5.heightH,
                      Text(
                        subtitle!,
                        style: context.h5b2,
                      ),
                      5.heightH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (hint.isNotNullOrEmpty)
                            Expanded(
                              child: Text(
                                hint!,
                                style: context.h6b2,
                              ),
                            ),
                          Container(
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                              color: context.primary,
                              borderRadius: BorderRadius.circular(12.sp),
                            ),
                            child: Icon(
                              AwesomeIconsRegular.angle_right,
                              size: 24.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
