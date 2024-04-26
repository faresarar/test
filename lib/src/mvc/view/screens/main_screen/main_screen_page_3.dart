import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';
import '../../screens.dart';

class MainScreenPage3 extends StatelessWidget {
  const MainScreenPage3({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          //header
          Container(
            color: context.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                context.viewPadding.top.height,
                24.heightH,
                1.sw.width,
                CircleAvatar(
                  radius: 50.sp,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 47.sp,
                    backgroundColor: context.primaryColor[50],
                    foregroundImage: userSession.photo ??
                        Image.asset('assets/images/avatar.png').image,
                  ),
                ),
                10.heightH,
                if (userSession.displayname.isNotNullOrEmpty)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          userSession.displayname!,
                          textAlign: TextAlign.center,
                          style: context.h3b1.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                24.heightH,
                Container(
                  height: 45.h,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: context.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(45.h),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //body
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.user_doctor,
                  title: 'Mes informations',
                  hasNotification: userSession.isProfileNotComplete,
                  onTap: () => userSession.openProfileInformation(context),
                  autoPop: false,
                ),
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.signature,
                  title: 'Insérer ma signature',
                  onTap: () => userSession.openProfileSignature(context),
                  hasNotification: userSession.signature == null,
                  autoPop: false,
                ),
                const CustomMenuListTile(
                  icon: AwesomeIconsRegular.users,
                  title: 'Mon équipe',
                  autoPop: false,
                ),
                CustomMenuListTile(
                  icon: AwesomeIconsLight.clipboard_medical,
                  title: 'Mes dispositifs médicaux',
                  onTap: () => context.push(
                    widget: MedecinesMy(
                      userSession: userSession,
                    ),
                  ),
                  autoPop: false,
                ),
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.users_medical,
                  title: 'Mes patients',
                  onTap: () => context.push(
                    widget: PatientsMy(
                      userSession: userSession,
                    ),
                  ),
                  autoPop: false,
                ),
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.lock_keyhole,
                  title: 'Modifier mon mot de passe',
                  onTap: () => context.push(
                    widget: ChangePassword(
                      userSession: userSession,
                    ),
                  ),
                  autoPop: false,
                ),
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.eraser,
                  title: 'Supprimer mon compte',
                  onTap: () => context.push(
                    widget: DeleteAccount(userSession: userSession),
                  ),
                  autoPop: false,
                ),
                CustomMenuListTile(
                  icon: AwesomeIconsRegular.arrow_right_from_bracket,
                  title: 'Se déconnecter',
                  color: Styles.red,
                  onTap: () => Dialogs.of(context).showAlertDialog(
                    dialogState: DialogState.confirmation,
                    subtitle: 'Êtes-vous sûr de vouloir vous déconnecter ?',
                    onContinue: () => Dialogs.of(context).runAsyncAction(
                      future: userSession.signOut,
                    ),
                    continueLabel: 'Se déconnecter',
                  ),
                  autoPop: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
