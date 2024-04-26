import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../tools.dart';
import '../../model/enums.dart';
import '../../model/models.dart';
import '../../model/models_ui.dart';
import '../screens.dart';

class MedecineTile extends StatelessWidget {
  const MedecineTile({
    super.key,
    required this.userSession,
    required this.index,
    required this.medecine,
    required this.onPick,
  });

  final UserSession userSession;
  final int index;
  final Medecine medecine;
  final void Function()? onPick;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: medecine,
      child: InkResponse(
        onTap: onPick ?? () => showMenu(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60.sp,
              height: 60.sp,
              decoration: BoxDecoration(
                image: medecine.photo != null
                    ? DecorationImage(
                        image: medecine.photo!,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      )
                    : null,
              ),
            ),
            14.widthSp,
            Consumer<Medecine>(
              builder: (context, patient, _) {
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.h4b1.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      Text(
                        patient.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.h5b2,
                      ),
                    ],
                  ),
                );
              },
            ),
            14.widthSp,
            Container(
              alignment: Alignment.center,
              width: 50.sp,
              child: IconButton(
                onPressed: () => showMenu(context),
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  AwesomeIconsRegular.ellipsis_vertical,
                  size: 18.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showMenu(BuildContext context) => Dialogs.of(context).showMenuDialog(
        [
          ModelTextButton(
            label: 'Modifier',
            icon: AwesomeIconsLight.pen_line,
            onPressed: () => context.push(
              widget: MedecinesCreate(
                userSession: userSession,
                medecine: medecine,
              ),
            ),
          ),
          ModelTextButton(
            label: 'Supprimer',
            icon: AwesomeIconsLight.trash,
            color: Styles.red,
            onPressed: () => Dialogs.of(context).showAlertDialog(
              subtitle:
                  'Êtes-vous sûr de vouloir supprimer ce dispositif médical?',
              onContinue: () => Dialogs.of(context).runAsyncAction(
                future: () async {
                  await userSession.listMedecines.delete(medecine);
                },
                onCompleteMessage: 'Dispositif médical a été supprimé!',
                dialogType: DialogType.snackbar,
              ),
              continueLabel: 'Supprimer',
            ),
          ),
        ],
      );
}
