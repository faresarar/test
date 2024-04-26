import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../model/models.dart';
import '../../../model/models_tools.dart';
import '../../model_widgets.dart';
import '../../screens.dart';
import '../../tiles.dart';

class MedecinesMy extends StatefulWidget {
  const MedecinesMy({
    super.key,
    required this.userSession,
    this.onPick,
  });

  final UserSession userSession;
  final void Function(Medecine)? onPick;

  @override
  State<MedecinesMy> createState() => _MedecinesMyState();
}

class _MedecinesMyState extends State<MedecinesMy> {
  TextEditingController textEditingController = TextEditingController();
  Debouncer debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    widget.userSession.listMedecines.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(
          widget: MedecinesCreate(
            userSession: widget.userSession,
            medecine: null,
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
              title: 'Identification du dispositif médical',
              subtitle:
                  'Veuillez sélectionner un dispositif médical ou en créer un.',
              constraints: BoxConstraints.tightFor(height: 150.sp),
            ),
            CustomTextFormField(
              controller: textEditingController,
              hintText: 'Trouver un dispositi ...',
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
              child: FirestoreSliverSetView<Medecine>(
                padding: EdgeInsets.symmetric(
                  vertical: 14.sp,
                ),
                list: widget.userSession.listMedecines,
                emptyTitle: 'Aucun dispositif médical!',
                emptySubtitle:
                    'Veuillez ajouter votre premier dispositif médical à VitaFit.',
                seperator: 14.heightH,
                builder: (context, index, medecine, list) => MedecineTile(
                  userSession: widget.userSession,
                  index: index,
                  medecine: medecine,
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
