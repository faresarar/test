import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../tools.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';

class MainScreenPage1 extends StatelessWidget {
  const MainScreenPage1({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.viewPadding.top.height,
          24.heightH,
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 20.w).copyWith(bottom: 24.h),
            child: Text(
              'Bienvenue ${userSession.firstName ?? ''}!',
              style: context.h1b1,
            ),
          ),
          Consumer<UserSession>(
            builder: (context, userSession, _) {
              return Visibility(
                visible: userSession.isProfileNotComplete,
                child: CustomElevatedContainer(
                  textDirection: TextDirection.rtl,
                  backgroundColor: context.primaryColor[50],
                  imageAsset: 'assets/images/Image_1.png',
                  children: [
                    Text(
                      'Oussama, compléter votre profil pour une meilleure expérience sur PansIA !',
                      style: context.h5b2,
                    ),
                    10.heightH,
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.sp),
                          ),
                        ),
                        onPressed: () =>
                            userSession.openProfileComplete(context),
                        icon: Icon(
                          AwesomeIconsRegular.arrow_right,
                          size: 18.sp,
                        ),
                        label: Text(
                          'Compléter',
                          style: context.h5b1.copyWith(
                            color: Colors.white,
                            fontWeight: Styles.semiBold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  onPressed: () => userSession.openProfileComplete(context),
                ),
              );
            },
          ),
          CustomElevatedContainer(
            textDirection: TextDirection.ltr,
            imageAsset: 'assets/images/Image_2.png',
            title: 'Analyse de plaie',
            subtitle:
                'Générer un protocole de soin et une ordonnance en quelques clics.',
            onPressed: () {},
          ),
          CustomElevatedContainer(
            textDirection: TextDirection.rtl,
            imageAsset: 'assets/images/Image_3.png',
            title: 'Générateur d\'ordonnance',
            subtitle: 'Générer une ordonnance rapidement et facilement.',
            hint: '*Réservé aux infirmiers libéraux',
            imageAlignment: Alignment.bottomCenter,
            onPressed: () {},
          ),
          CustomElevatedContainer(
            textDirection: TextDirection.ltr,
            imageAsset: 'assets/images/Image_4.png',
            title: 'Calculateur de dose',
            subtitle: 'Déterminer le bon dosage à administrer à votre patient.',
            imageAlignment: Alignment.bottomCenter,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
