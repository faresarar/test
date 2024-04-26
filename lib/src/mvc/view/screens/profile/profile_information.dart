import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? photoPath;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? adeli;

  @override
  void initState() {
    super.initState();
    firstName = widget.userSession.firstName;
    lastName = widget.userSession.lastName;
    birthDate = widget.userSession.birthDate;
    adeli = widget.userSession.adeli;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    title: 'Compléter mon profil',
                    subtitle:
                        'Compléter ou mettez à jour votre profil pour une meilleure expérience sur PansIA !',
                    constraints: BoxConstraints.tightFor(height: 150.sp),
                  ),
                  Center(
                    child: CustomProfilePhotoPicker(
                      photo: widget.userSession.photo,
                      initialPhotoPath: photoPath,
                      onChanged: (path) {
                        photoPath = path;
                      },
                    ),
                  ),
                  42.heightH,
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
                      textInputAction: TextInputAction.next,
                      validator: Validators.validateNotNull,
                      onSaved: (value) => birthDate = value,
                    ),
                  ),
                  CustomTextFormField(
                    hintText: 'Numéro ADELI',
                    initialValue: adeli,
                    keyboardType: TextInputType.number,
                    prefixIcon: AwesomeIconsLight.input_numeric,
                    suffixIcon: AwesomeIconsLight.circle_info,
                    textInputAction: TextInputAction.done,
                    validator: Validators.validateNumberInt,
                    onSaved: (value) => adeli = value,
                    onEditingComplete: submit,
                  ),
                  42.heightH,
                  const Spacer(),
                  CustomElevatedButton(
                    label: 'Enregistrer',
                    onPressed: submit,
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

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await Dialogs.of(context).runAsyncAction(
      future: () async {
        await widget.userSession.completeProfile(
          photoPath: photoPath,
          firstName: firstName,
          lastName: lastName,
          birthDate: birthDate,
          adeli: adeli,
          signiture: null,
        );
      },
      onComplete: (_) => context.pop(),
      onCompleteMessage: 'Votre profil a été mis à jour!',
      dialogType: DialogType.snackbar,
    );
  }
}
