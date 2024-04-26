import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../tools.dart';

class CustomFloatingProgressAction extends StatelessWidget {
  const CustomFloatingProgressAction({
    super.key,
    required this.pageController,
    required this.isLastPage,
    required this.onPressed,
  });

  final PageController pageController;
  final bool isLastPage;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70.sp,
      width: 70.sp,
      child: FittedBox(
        child: FloatingActionButton.small(
          backgroundColor: context.primary,
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.all(4.sp),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      value: ((pageController.page ?? 0) + 1) / 3,
                      strokeWidth: 2.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Icon(
                      AwesomeIconsRegular.angle_right,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
