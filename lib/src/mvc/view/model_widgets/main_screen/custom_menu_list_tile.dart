import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';

class CustomMenuListTile extends StatelessWidget {
  const CustomMenuListTile({
    super.key,
    required this.icon,
    required this.title,
    this.hasNotification = false,
    required this.autoPop,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final String title;
  final bool hasNotification;
  final bool autoPop;
  final void Function()? onTap;
  final MaterialColor? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: ListTile(
        onTap: () {
          if (autoPop) {
            context.pop();
          }
          if (onTap != null) {
            onTap!();
          }
        },
        visualDensity: VisualDensity.compact,
        leading: Container(
          padding: EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.sp),
            color: (color ?? context.primaryColor)[50],
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: color ?? context.primary,
          ),
        ),
        title: Text(
          title,
          style: context.h4b1.copyWith(
            color: color,
          ),
        ),
        trailing: onTap == null
            ? Text(
                '(Bientôt)',
                style: context.h6b1.copyWith(color: Colors.red),
              )
            : hasNotification
                ? Container(
                    width: 10.sp,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
      ),
    );
  }
}
