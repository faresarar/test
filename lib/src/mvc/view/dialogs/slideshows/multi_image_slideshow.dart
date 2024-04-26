import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../tools.dart';

class MultiImageSlideshow extends StatefulWidget {
  const MultiImageSlideshow({
    super.key,
    required this.images,
    required this.initialPage,
  });

  final List<ImageProvider<Object>> images;
  final int initialPage;

  @override
  State<MultiImageSlideshow> createState() => _MultiImageSlideshowState();
}

class _MultiImageSlideshowState extends State<MultiImageSlideshow> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: pageController,
          itemBuilder: (context, index) => InteractiveViewer(
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
                  image: widget.images[index],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          itemCount: widget.images.length,
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
        Positioned.fill(
          bottom: 40,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SmoothPageIndicator(
              controller: pageController,
              count: widget.images.length,
              effect: WormEffect(
                activeDotColor: Colors.white,
                dotColor: Colors.white60,
                strokeWidth: 2.sp,
                dotHeight: 6.sp,
                dotWidth: 6.sp,
                spacing: 5.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
