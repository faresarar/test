import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';

class SingleImageSlideshow extends StatelessWidget {
  const SingleImageSlideshow({
    super.key,
    required this.image,
  });

  final ImageProvider<Object> image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          scaleEnabled: true,
          panEnabled: true, // Set it to false to prevent panning.
          boundaryMargin: EdgeInsets.zero,
          minScale: 1,
          maxScale: 3,
          child: Container(
            height: 1.sh,
            width: 1.sw,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image,
                fit: BoxFit.contain,
              ),
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
