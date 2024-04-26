import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../model/models.dart';
import '../../../model/models_tools.dart';
import '../../model_widgets.dart';
import '../../screens.dart';
import '../../tiles.dart';

class PatientsMy extends StatefulWidget {
  const PatientsMy({
    super.key,
    required this.userSession,
    this.onPick,
  });

  final UserSession userSession;
  final void Function(Patient)? onPick;

  @override
  State<PatientsMy> createState() => _PatientsMyState();
}

class _PatientsMyState extends State<PatientsMy> {
  TextEditingController textEditingController = TextEditingController();
  Debouncer debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    widget.userSession.listPatients.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(
          widget: PatientsCreate(
            userSession: widget.userSession,
            patient: null,
          ),
        ),
        child: const Icon(
          AwesomeIconsRegular.plus,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Customheader(
              title: 'Identification du patient',
              subtitle: 'Veuillez sélectionner un patient ou en créer un.',
              constraints: BoxConstraints.tightFor(height: 110.sp),
            ),
            CustomTextFormField(
              controller: textEditingController,
              hintText: 'Trouver un patient ...',
              prefixIcon: AwesomeIconsLight.magnifying_glass,
              suffixIcon: AwesomeIconsRegular.xmark,
              onChanged: (value) {
                debouncer.run(() {
                  //FIXME on change search text
                });
              },
            ),
            14.heightSp,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 60.sp,
                  child: Text(
                    'N°',
                    style: context.h5b2,
                  ),
                ),
                14.widthSp,
                Expanded(
                  child: Text(
                    'Nom',
                    style: context.h5b2,
                  ),
                ),
                14.widthSp,
                Container(
                  alignment: Alignment.center,
                  width: 50.sp,
                  child: Text(
                    'Action',
                    style: context.h5b2,
                  ),
                ),
              ],
            ),
            Expanded(
              child: FirestoreSliverSetView<Patient>(
                padding: EdgeInsets.symmetric(
                  vertical: 14.sp,
                ),
                list: widget.userSession.listPatients,
                emptyTitle: 'Aucun patient!',
                emptySubtitle:
                    'Veuillez ajouter votre premier patient à VitaFit.',
                seperator: 14.heightH,
                builder: (context, index, patient, list) => PatientTile(
                  userSession: widget.userSession,
                  index: index,
                  patient: patient,
                  onPick: null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
