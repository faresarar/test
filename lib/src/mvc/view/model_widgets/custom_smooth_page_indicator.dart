import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../tools.dart';

class CustomSmoothPageIndicator extends StatelessWidget {
  const CustomSmoothPageIndicator({
    super.key,
    required this.count,
    required this.controller,
  });

  final int count;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: CustomizableEffect(
        dotDecoration: DotDecoration(
          color: context.primaryColor[500]!,
          borderRadius: BorderRadius.circular(3.sp),
          height: 10.sp,
          width: 20.sp,
        ),
        activeDotDecoration: DotDecoration(
          color: context.primary,
          borderRadius: BorderRadius.circular(3.sp),
          height: 10.sp,
          width: 20.sp,
        ),
        spacing: 6.sp,
      ),
    );
  }
}
