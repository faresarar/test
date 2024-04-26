import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../tools.dart';

class CustomScreenHeader extends StatelessWidget {
  const CustomScreenHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.topPadding,
    this.bottomPadding,
  });

  final String title;
  final String subtitle;
  final double? topPadding;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 80.sp + 60.h),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.heightH,
            Text(
              title,
              style: context.h1b1,
            ),
            10.heightH,
            Text(
              subtitle,
              style: context.h5b1,
            ),
            30.heightH,
          ],
        ),
      ),
    );
  }
}
