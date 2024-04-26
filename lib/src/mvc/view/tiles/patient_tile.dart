import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../tools.dart';
import '../../model/enums.dart';
import '../../model/models.dart';
import '../../model/models_ui.dart';
import '../screens.dart';

class PatientTile extends StatelessWidget {
  const PatientTile({
    super.key,
    required this.userSession,
    required this.index,
    required this.patient,
    required this.onPick,
  });

  final UserSession userSession;
  final int index;
  final Patient patient;
  final void Function()? onPick;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: patient,
      child: InkResponse(
        onTap: onPick ?? () => showMenu(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.sp),
                color: Styles.black[100],
              ),
              child: Text(
                NumberFormat('#00').format(index + 1),
                style: context.h3b1,
              ),
            ),
            14.widthSp,
            Consumer<Patient>(
              builder: (context, patient, _) {
                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.h4b1.copyWith(
                          fontSize: 18.sp,
                        ),
                      ),
                      Text(
                        patient.birthDate,
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
              widget: PatientsCreate(
                userSession: userSession,
                patient: patient,
              ),
            ),
          ),
          ModelTextButton(
            label: 'Supprimer',
            icon: AwesomeIconsLight.trash,
            color: Styles.red,
            onPressed: () => Dialogs.of(context).showAlertDialog(
              subtitle: 'Êtes-vous sûr de vouloir supprimer ce patient?',
              onContinue: () => Dialogs.of(context).runAsyncAction(
                future: () async {
                  await userSession.listPatients.delete(patient);
                },
                onCompleteMessage: 'Patient a été supprimé!',
                dialogType: DialogType.snackbar,
              ),
              continueLabel: 'Supprimer',
            ),
          ),
        ],
      );
}
