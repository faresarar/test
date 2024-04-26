import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart' as badge;

import '../../../tools.dart';
import '../../model/models.dart';
import '../model_widgets.dart';

/// Splash screen, it shows when the app is opened and is still preparing data
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.userSession});

  /// user session
  final UserSession userSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          PositionedDirectional(
            top: 0,
            end: 0,
            child: Image.asset(
              'assets/images/splashscreen_top.png',
              width: 170.h,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            child: Image.asset(
              'assets/images/splashscreen_bottom.png',
              width: 190.h,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Center(
            child: Column(
              children: [
                (context.viewPadding.top).height,
                1.sw.width,
                const Spacer(),
                if (userSession.error == null) ...[
                  Image.asset(
                    'assets/images/splashscreen_logo.png',
                    height: 330.sp,
                    width: 1.sw,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 90.sp),
                ],
                if (userSession.error != null) ...[
                  const Spacer(flex: 2),
                  const Spacer(),
                  badge.Badge(
                    badgeStyle: const badge.BadgeStyle(
                      badgeColor: Colors.transparent,
                      elevation: 0,
                    ),
                    position: badge.BadgePosition.topEnd(
                      top: -8.sp,
                      end: -8.sp,
                    ),
                    badgeAnimation: const badge.BadgeAnimation.scale(
                      animationDuration: Duration(milliseconds: 100),
                      disappearanceFadeAnimationDuration:
                          Duration(milliseconds: 50),
                    ),
                    badgeContent: Icon(
                      Icons.bug_report,
                      size: 35.sp,
                      color: Styles.red,
                    ),
                    child: Icon(
                      Icons.warning_amber,
                      size: 90.sp,
                      color: context.primary,
                    ),
                  ),
                  SizedBox(height: 40.sp),
                  Text(
                    AppLocalizations.of(context)!.oops,
                    style: context.h2b1,
                  ),
                  SizedBox(height: 8.sp),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.sp),
                    child: Text(
                      Functions.of(context)
                          .translateException(userSession.error!),
                      textAlign: TextAlign.center,
                      style: context.h5b3,
                    ),
                  ),
                  const Spacer(flex: 3),
                  CustomElevatedButton(
                    label: AppLocalizations.of(context)!.logout,
                    onPressed: userSession.signOut,
                  ),
                ],
                const Spacer(),
                FutureBuilder(
                  future:
                      PackageInfo.fromPlatform().then((value) => value.version),
                  builder: (context, snapshot) {
                    return SizedBox(
                      height: 20.sp,
                      child: snapshot.hasData
                          ? Text(
                              'Version: ${snapshot.data!}',
                              style: context.h5b2,
                            )
                          : null,
                    );
                  },
                ),
                (context.viewPadding.bottom + 10.h).height,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
