import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../extensions.dart';

class CustomArrowTile extends StatelessWidget {
  const CustomArrowTile({
    super.key,
    this.margin,
  });

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: context.primaryColor.shade100,
          margin: margin ?? EdgeInsets.only(top: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.sp),
          ),
          elevation: 2.0,
          child: Container(
            height: 41.sp,
            width: 41.sp,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_downward,
              color: context.primary,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
