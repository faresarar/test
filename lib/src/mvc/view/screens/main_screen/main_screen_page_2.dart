import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../tools.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';

class MainScreenPage2 extends StatelessWidget {
  const MainScreenPage2({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(
        top: context.viewPadding.top,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/Empty-pana.svg',
            width: 0.7.sw,
            height: 0.7.sw,
            alignment: Alignment.center,
            fit: BoxFit.contain,
          ),
          38.heightH,
          Text(
            'Mes dossiers patient',
            textAlign: TextAlign.center,
            style: context.h3b1,
          ),
          12.heightH,
          Text(
            'Retrouvez ici les analyses de plaies, les protocoles de soins et les ordonnances organisés par patient afin de faciliter vos transmissions.',
            textAlign: TextAlign.center,
            style: context.h5b2,
          ),
          38.heightH,
          CustomElevatedButton(
            label: 'Analyse de plaie',
            fontSize: 16.sp,
            minimumSize: Size(185.sp, 44.sp),
            fixedSize: Size(185.sp, 44.sp),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
