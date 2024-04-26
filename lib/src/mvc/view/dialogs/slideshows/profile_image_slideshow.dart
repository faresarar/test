import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';

class ProfileImageSlideshow extends StatelessWidget {
  const ProfileImageSlideshow({
    super.key,
    required this.image,
  });

  final ImageProvider<Object> image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: InkResponse(
              onTap: context.pop,
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ),
        Container(
          height: 1.sh,
          width: 1.sw,
          padding: EdgeInsets.all(5.sp),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: image,
              fit: BoxFit.contain,
            ),
          ),
        ),
        PositionedDirectional(
          top: Paddings.viewPadding.top,
          end: 0,
          child: SizedBox(
            height: 56,
            width: 56,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: context.pop,
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
