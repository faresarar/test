import 'package:flutter/material.dart';

import '../../../../../custom_widgets/CustomTextFormField.dart';
import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../screens.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    super.key,
    required this.userSession,
    required this.authRouteNotifier,
  });

  final UserSession userSession;
  final ValueNotifier<AuthRoute> authRouteNotifier;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? email;
  String? emailError;

  @override
  Widget build(BuildContext context) {
    return AuthenticationPage(
      userSession: widget.userSession,
      onPressedLeadingAppBar: null,
      title: 'Réinitialiser votre mot de passe',
      subtitle:
          'Un lien de réinitialisation de votre mot de passe va vous être envoyé par e-mail.',
      formKey: formKey,
      bodyChildren: [
        CustomTextFormField(
          hintText: 'Email',
          //errorText: emailError,
          //keyboardType: TextInputType.emailAddress,
          prefixIcon: AwesomeIconsLight.at,
          validator: Validators.validateEmail,
          onSaved: (value) => email = value,
          //onEditingComplete: validateSaveAndCallNext,
          onChanged: (String value) {  },
        ),
      ],
      labelAuthButton: 'Envoyer',
      onPressedAuthButton: next,
      normalTextSpan: 'Vous avez récupéré votre mot de passe ?',
      highlightedTextSpan: 'Se connecter',
      recognizerTextSpan: context.pop,
    );
  }

  Future<void> validateSaveAndCallNext() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await next();
  }

  Future<void> next() async {
    if (emailError.isNotNullOrEmpty) {
      setState(() {
        emailError = null;
      });
    }
    await Dialogs.of(context).runAsyncAction(
      future: () => AuthenticationService.sendPasswordResetEmail(email: email!),
      onCompleteMessage:
          'Un lien de réinitialisation de votre mot de passe a été envoyé par e-mail.',
      dialogType: DialogType.snackbar,
      onError: (e) {
        setState(() {
          emailError = Functions.of(context).translateException(e);
        });
      },
    );
  }
}
