import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../tools.dart';

class CustomFloatingFlatActionButton extends StatelessWidget {
  const CustomFloatingFlatActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: DateTime.now().millisecond,
      onPressed: onPressed,
      backgroundColor: context.scaffoldBackgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.sp),
        side: BorderSide(
          color: context.b1,
          width: 2.sp,
        ),
      ),
      child: Icon(
        icon,
        size: 24,
        color: context.b1,
      ),
    );
  }
}
