import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';

class SubmitUserFeedback extends StatefulWidget {
  const SubmitUserFeedback({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  State<SubmitUserFeedback> createState() => _SubmitUserFeedbackState();
}

class _SubmitUserFeedbackState extends State<SubmitUserFeedback> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? text;

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            const Customheader(
              title: 'Idées d\'améliorations',
              subtitle:
                  'Partagez vos idées lumineuses et façonnez l\'avenir des soins médicaux avec nous ! Votre contribution compte, chaque suggestion nous rapproche d\'une pratique médicale encore plus efficace et attentionnée. Rejoignez-nous pour faire évoluer VitaFit.',
              // constraints: BoxConstraints.tightFor(height: 150.sp),
            ),
            Form(
              key: formKey,
              child: CustomTextFormField(
                hintText: 'Commencer à écrire',
                // prefixIcon: AwesomeIconsLight.text,
                textInputAction: TextInputAction.done,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                validator: Validators.validateNotNull,
                onSaved: (value) => text = value,
                onEditingComplete: submit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await Dialogs.of(context).runAsyncAction(
      future: () async {
        await FeedbackService.create(
          userSession: widget.userSession,
          message: text!,
        );
      },
      onComplete: (_) => context.pop(),
      onCompleteMessage: 'Merci pour votre contribution!',
      dialogType: DialogType.snackbar,
    );
  }
}
