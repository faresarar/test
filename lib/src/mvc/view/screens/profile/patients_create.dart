import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';

class PatientsCreate extends StatefulWidget {
  const PatientsCreate({
    super.key,
    required this.userSession,
    required this.patient,
  });

  final UserSession userSession;
  final Patient? patient;

  @override
  State<PatientsCreate> createState() => _PatientsCreateState();
}

class _PatientsCreateState extends State<PatientsCreate> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? firstName;
  String? lastName;
  String? birthDate;

  @override
  void initState() {
    super.initState();
    firstName = widget.patient?.firstName;
    lastName = widget.patient?.lastName;
    birthDate = widget.patient?.birthDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: context.isKeyboardNotVisible
          ? CustomElevatedButton(
              label: 'Enregistrer',
              onPressed: submit,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightForFinite(
            height: 1.sh - 56 - context.viewPadding.top,
          ),
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Customheader(
                    title: 'Nouveau patient',
                    subtitle: 'Créer et ajouter un nouveau patient.',
                    constraints: BoxConstraints.tightFor(height: 150.sp),
                  ),
                  // 42.heightH,
                  CustomTextFormField(
                    hintText: 'Nom',
                    initialValue: lastName,
                    keyboardType: TextInputType.name,
                    prefixIcon: AwesomeIconsLight.address_card,
                    textInputAction: TextInputAction.next,
                    validator: Validators.validateNotNull,
                    onSaved: (value) => lastName = value,
                  ),
                  CustomTextFormField(
                    hintText: 'Prénom',
                    initialValue: firstName,
                    keyboardType: TextInputType.name,
                    prefixIcon: AwesomeIconsLight.address_card,
                    textInputAction: TextInputAction.next,
                    validator: Validators.validateNotNull,
                    onSaved: (value) => firstName = value,
                  ),
                  SizedBox(
                    width: 0.4.sw,
                    child: CustomTextFormField(
                      hintText: 'Date de naissance',
                      initialValue: birthDate,
                      keyboardType: TextInputType.datetime,
                      prefixIcon: AwesomeIconsLight.calendar,
                      textInputAction: TextInputAction.done,
                      validator: Validators.validateNotNull,
                      onSaved: (value) => birthDate = value,
                      onEditingComplete: submit,
                    ),
                  ),
                  (context.viewPadding.bottom + 20).height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get isEditing => widget.patient != null;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await Dialogs.of(context).runAsyncAction(
      future: () async {
        if (isEditing) {
          widget.patient!.firstName = firstName!;
          widget.patient!.lastName = lastName!;
          widget.patient!.birthDate = birthDate!;
          await widget.patient?.update();
        } else {
          Patient patient = Patient.init(
            userSession: widget.userSession,
            firstName: firstName!,
            lastName: lastName!,
            birthDate: birthDate!,
          );
          await widget.userSession.listPatients.create(patient);
        }
      },
      onComplete: (_) => context.pop(),
      onCompleteMessage: isEditing
          ? 'Votre patient a été mis à jour.'
          : 'Votre patient a été crée.',
      dialogType: DialogType.snackbar,
    );
  }
}
