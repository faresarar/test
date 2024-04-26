import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../tools.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';

class MedecinesCreate extends StatefulWidget {
  const MedecinesCreate({
    super.key,
    required this.userSession,
    required this.medecine,
  });

  final UserSession userSession;
  final Medecine? medecine;

  @override
  State<MedecinesCreate> createState() => _MedecinesCreateState();
}

class _MedecinesCreateState extends State<MedecinesCreate> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? name;
  String? description;
  String? photoPath;

  @override
  void initState() {
    super.initState();
    name = widget.medecine?.name;
    description = widget.medecine?.description;
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
                    title: 'Nouveau dispositif médical',
                    subtitle: 'Créer et ajouter un nouveau dispositif médical.',
                    constraints: BoxConstraints.tightFor(height: 150.sp),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) {
                            return InkResponse(
                              onTap: () => ModernPicker.of(context)
                                  .showClassicSingleImagePicker(
                                source: ImageSource.gallery,
                                onComplete: (xfile) {
                                  setState(() {
                                    photoPath = xfile.path;
                                  });
                                },
                              ),
                              child: Container(
                                padding: EdgeInsets.all(20.sp),
                                width: 74.sp,
                                height: 74.sp,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.sp),
                                  color: context.primaryColor[50],
                                  image: photoPath != null ||
                                          widget.medecine?.photo != null
                                      ? DecorationImage(
                                          image: photoPath != null
                                              ? Image.asset(photoPath!).image
                                              : widget.medecine!.photo!,
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                        )
                                      : null,
                                ),
                                child: photoPath != null ||
                                        widget.medecine?.photo != null
                                    ? null
                                    : Icon(
                                        AwesomeIconsLight.image,
                                        color: context.primary,
                                        size: 34.sp,
                                      ),
                              ),
                            );
                          },
                        ),
                        12.heightH,
                        Text(
                          'Importer une photo',
                          style: context.h5b2,
                        ),
                      ],
                    ),
                  ),
                  54.heightH,
                  CustomTextFormField(
                    hintText: 'Nom dispositif',
                    initialValue: name,
                    keyboardType: TextInputType.name,
                    prefixIcon: AwesomeIconsLight.text,
                    textInputAction: TextInputAction.next,
                    validator: Validators.validateNotNull,
                    onSaved: (value) => name = value,
                  ),
                  CustomTextFormField(
                    hintText: 'Déscription',
                    initialValue: description,
                    keyboardType: TextInputType.name,
                    prefixIcon: AwesomeIconsLight.text,
                    textInputAction: TextInputAction.done,
                    validator: Validators.validateNotNull,
                    onSaved: (value) => description = value,
                    onEditingComplete: submit,
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

  bool get isEditing => widget.medecine != null;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await Dialogs.of(context).runAsyncAction(
      future: () async {
        if (isEditing) {
          widget.medecine!.name = name!;
          widget.medecine!.description = description!;
          widget.medecine!.photoUrl = photoPath;
          await widget.medecine?.update();
        } else {
          Medecine medecine = Medecine.init(
            userSession: widget.userSession,
            name: name!,
            description: description!,
            photoPath: photoPath!,
          );
          await widget.userSession.listMedecines.create(medecine);
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
