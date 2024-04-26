import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../model_widgets.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({
    super.key,
    required this.userSession,
  });

  final UserSession userSession;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? oldPassword, newPassword, confirmPassword;
  String? oldPasswordError, newPasswordError, passwordRetypeError;
  bool obscureText = true;

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
            Customheader(
              title: 'Modifier mon mot de passe',
              subtitle:
                  'Suivez les indications ci-dessous pour modifier votre mot de passe.',
              constraints: BoxConstraints.tightFor(height: 150.sp),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    hintText: 'Ancien mot de passe',
                    errorText: oldPasswordError,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: AwesomeIconsLight.lock_keyhole,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        Validators.of(context).validateNotNullMinLength(
                      value: value,
                      minLength: 6,
                    ),
                    onSaved: (value) => oldPassword = value,
                    suffixIcon: obscureText
                        ? AwesomeIconsLight.eye_slash
                        : AwesomeIconsLight.eye,
                    obscureText: obscureText,
                    suffixOnTap: () =>
                        setState(() => obscureText = !obscureText),
                  ),
                  CustomTextFormField(
                    hintText: 'Nouveau mot de passe',
                    errorText: newPassword,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: AwesomeIconsLight.lock_keyhole,
                    textInputAction: TextInputAction.next,
                    validator: (value) =>
                        Validators.of(context).validateNotNullMinLength(
                      value: value,
                      minLength: 6,
                    ),
                    onSaved: (value) => newPassword = value,
                    suffixIcon: obscureText
                        ? AwesomeIconsLight.eye_slash
                        : AwesomeIconsLight.eye,
                    obscureText: obscureText,
                    suffixOnTap: () =>
                        setState(() => obscureText = !obscureText),
                  ),
                  CustomTextFormField(
                    hintText: 'Confirmez votre mot de passe',
                    errorText: passwordRetypeError,
                    keyboardType: TextInputType.visiblePassword,
                    prefixIcon: AwesomeIconsLight.lock_keyhole,
                    validator: Validators.validateNotNull,
                    onSaved: (value) => confirmPassword = value,
                    obscureText: obscureText,
                    onEditingComplete: submit,
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
    if (oldPasswordError.isNotNullOrEmpty ||
        newPasswordError.isNotNullOrEmpty ||
        passwordRetypeError.isNotNullOrEmpty) {
      setState(() {
        oldPasswordError = null;
        newPasswordError = null;
        passwordRetypeError = null;
      });
    }

    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    if (newPassword != confirmPassword) {
      setState(() {
        passwordRetypeError = 'Veuillez confirmer votre mot de passe!';
      });
      return;
    }
    await Dialogs.of(context).runAsyncAction(
      future: () async {
        await AuthenticationService.changePassword(
          email: widget.userSession.email!,
          oldPassword: oldPassword!,
          newPassword: newPassword!,
        );
      },
      onError: (e) {
        try {
          throw e;
        } on FirebaseException catch (e) {
          switch (e.code) {
            case 'weak-password':
              setState(() {
                newPasswordError =
                    Functions.of(context).translateExceptionKey(e.code);
              });
              break;
            case 'wrong-password':
              setState(() {
                oldPasswordError =
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
      onComplete: (_) => context.pop(),
      onCompleteMessage: 'Votre mot de passe a été modifié!',
      dialogType: DialogType.snackbar,
    );
  }
}
