import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../extensions.dart';

class CustomEmptyListView extends StatelessWidget {
  const CustomEmptyListView({
    super.key,
    required this.title,
    required this.subtitle,
    this.iconData,
    this.isSliver = true,
    this.padding,
  });

  final String title;
  final String subtitle;
  final IconData? iconData;
  final bool isSliver;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    var child = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          iconData ?? Icons.info_outline,
          size: 40.sp,
          color: Theme.of(context).textTheme.displayMedium!.color,
        ),
        SizedBox(height: 30.h),
        Text(
          title,
          style: context.h4b1,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: context.h5b1.copyWith(fontSize: 15.sp),
        ),
      ],
    );
    if (isSliver) {
      return SliverPadding(
        padding: padding ?? EdgeInsets.fromLTRB(20.sp, 150.h, 20.sp, 0),
        sliver: SliverToBoxAdapter(
          child: child,
        ),
      );
    }
    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(20.sp, 150.h, 20.sp, 0),
      child: child,
    );
  }
}
