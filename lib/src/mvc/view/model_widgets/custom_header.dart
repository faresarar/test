import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../tools.dart';

class Customheader extends StatelessWidget {
  const Customheader({
    super.key,
    required this.title,
    required this.subtitle,
    this.constraints,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final String title;
  final String subtitle;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(vertical: 24.h),
      constraints: constraints,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: mainAxisAlignment,
        children: [
          1.sw.width,
          Text(
            title,
            style: context.h2b1.copyWith(
              fontFamily: 'Montserrat',
              fontWeight: Styles.bold,
            ),
          ),
          8.heightH,
          Text(
            subtitle,
            style: context.h5b2,
          ),
        ],
      ),
    );
  }
}
