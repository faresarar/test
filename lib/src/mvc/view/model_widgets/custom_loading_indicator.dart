import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../extensions.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
    this.isSliver = true,
    this.margin,
  });

  final bool isSliver;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    var child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: margin ?? EdgeInsets.only(top: 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.sp),
          ),
          elevation: 2.0,
          child: Container(
            height: 41.sp,
            width: 41.sp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: SpinKitRing(
              color: context.primary,
              size: 20.sp,
              lineWidth: 2.3.sp,
            ),
          ),
        ),
      ],
    );
    if (isSliver) {
      return SliverToBoxAdapter(
        child: child,
      );
    } else {
      return child;
    }
  }
}
