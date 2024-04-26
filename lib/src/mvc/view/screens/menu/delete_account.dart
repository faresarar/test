import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? password, passwordError, why;
  bool obscureText = true;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: context.isKeyboardNotVisible
          ? CustomElevatedButton(
              label: 'Supprimer mon compte',
              onPressed: submit,
              color: Styles.red,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Customheader(
              title: 'Supprimer mon compte',
              subtitle:
                  'Vous souhaitez supprimer votre compte ? Nous sommes triste de vous voir partir 😕.',
              constraints: BoxConstraints.tightFor(height: 150.sp),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    hintText: 'Ancien mot de passe',
                    errorText: passwordError,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: AwesomeIconsLight.lock_keyhole,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        Validators.of(context).validateNotNullMinLength(
                      value: value,
                      minLength: 6,
                    ),
                    onSaved: (value) => password = value,
                    suffixIcon: obscureText
                        ? AwesomeIconsLight.eye_slash
                        : AwesomeIconsLight.eye,
                    obscureText: obscureText,
                    suffixOnTap: () =>
                        setState(() => obscureText = !obscureText),
                  ),
                  CustomTextFormField(
                    controller: textEditingController,
                    hintText: 'Pourquoi supprimer votre compte?',
                    prefixIcon: AwesomeIconsLight.circle_question,
                    textInputAction: TextInputAction.next,
                    validator: Validators.validateNotNull,
                    onSaved: (value) => why = value,
                    suffixIcon: AwesomeIconsRegular.angle_down,
                    readOnly: true,
                    onTap: () =>
                        Dialogs.of(context).showSingleValuePickerDialog(
                      title: 'Pourquoi supprimer votre compte?',
                      searchable: false,
                      values: [
                        'Ne m\'intéresse pas',
                        'Informations erronées',
                        'Fonctionnalités limitées',
                        'Trop cher',
                        'Trop de publicité',
                        'Trop de bug',
                        'Autre',
                      ],
                      initialvalue: why,
                      onPick: (value) {
                        textEditingController.text = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (passwordError.isNotNullOrEmpty) {
      setState(() {
        passwordError = null;
      });
    }
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await Dialogs.of(context).runAsyncAction(
      future: () async {
        await AuthenticationService.deleteAccount(
          userSession: widget.userSession,
          oldPassword: password!,
          why: why!,
        );
      },
      onError: (e) {
        try {
          throw e;
        } on FirebaseException catch (e) {
          switch (e.code) {
            case 'wrong-password':
              setState(() {
                passwordError =
                    Functions.of(context).translateExceptionKey(e.code);
              });
              break;
            default:
              context.showSnackBar(
                Functions.of(context).translateExceptionKey(e.code),
              );
          }
        } catch (e) {
          context.showSnackBar(
            AppLocalizations.of(context)!.unknown_error,
          );
        }
      },
      onComplete: (_) => context.popUntilFirst(),
      onCompleteMessage: 'Votre compte a été supprimé!',
      dialogType: DialogType.snackbar,
    );
  }
}
