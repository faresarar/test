import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../model_widgets.dart';

class CustomAuthenticationButton extends StatelessWidget {
  const CustomAuthenticationButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.normalTextSpan,
    required this.highlightedTextSpan,
    required this.recognizerTextSpan,
  });

  final String label;
  final void Function() onPressed;
  final String? normalTextSpan;
  final String? highlightedTextSpan;
  final void Function()? recognizerTextSpan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          label: label,
          onPressed: onPressed,
        ),
        12.heightH,
        SizedBox(
          height: 44.sp,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: context.h5b1.copyWith(height: 1.5),
              children: [
                if (normalTextSpan.isNotNullOrEmpty)
                  TextSpan(
                    text: '$normalTextSpan ',
                    recognizer: TapGestureRecognizer()
                      ..onTap = recognizerTextSpan,
                  ),
                if (highlightedTextSpan.isNotNullOrEmpty)
                  TextSpan(
                    text: highlightedTextSpan,
                    style: context.h5b1.copyWith(
                      color: context.secondary,
                      height: 1.5,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = recognizerTextSpan,
                  ),
              ],
            ),
          ),
        ),
        17.heightH,
      ],
    );
  }
}
