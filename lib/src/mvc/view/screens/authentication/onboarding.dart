import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../.././../../tools.dart';
import '../../../../settings/settings_controller.dart';
import '../../../model/models_ui.dart';
import '../../model_widgets.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return Visibility(
                visible: (controller.page ?? 0) <= 2,
                child: CustomTextButton(
                  button: ModelTextButton(
                    label: 'Passer',
                    onPressed: () =>
                        widget.settingsController.updateShowOnboarding(false),
                  ),
                ),
              );
            },
          ),
          15.widthW,
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView(
              controller: controller,
              children: [
                const Page(
                  svgPath: 'assets/images/Doctors-pana.svg',
                  title: 'Bienvenue chez VitaFit !',
                  subtitle:
                      'Votre assistant de santé ultime ouvert à tous : une application conçue par des experts de la santé, évoluant en fonction de vos besoins ! ',
                ),
                Page(
                  svgPath: 'assets/images/Mobile Marketing-pana.svg',
                  title: 'Une solution tout-en-un',
                  subtitle:
                      'Analysez les plaies, générez rapidement des protocoles de soins et des ordonnances infirmières, avec une organisation par dossier patient pour une transmission facile.',
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                ),
                Page(
                  svgPath: 'assets/images/Medical prescription-pana.svg',
                  title: 'Des ordonnances en un clin d\'œil',
                  subtitle:
                      'Transformez votre smartphone en outil de productivité médicale : générez des ordonnances en toute simplicité !',
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                ),
                const Page(
                  svgPath: 'assets/images/Online Doctor-pana.svg',
                  title: 'Gratuit et Essentiel !',
                  subtitle:
                      'Découvrez VitaFit, votre allié santé ultime, avec des fonctionnalités évolutives pour simplifier votre quotidien, le tout gratuitement, sans frais cachés !',
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                80.heightH,
                Row(
                  children: [
                    CustomSmoothPageIndicator(
                      count: 4,
                      controller: controller,
                    ),
                    const Spacer(),
                    FloatingActionButton(
                      onPressed: () => (controller.page ?? 0) <= 2
                          ? controller.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            )
                          : widget.settingsController
                              .updateShowOnboarding(false),
                      child: const Icon(
                        AwesomeIconsRegular.arrow_right_long,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          (context.viewPadding.bottom + 40.h).height,
        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
    required this.svgPath,
    required this.title,
    required this.subtitle,
    this.padding,
  });

  final String svgPath;
  final String title;
  final String subtitle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: SvgPicture.asset(
                svgPath,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Customheader(
              title: title,
              subtitle: subtitle,
              mainAxisAlignment: MainAxisAlignment.end,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
