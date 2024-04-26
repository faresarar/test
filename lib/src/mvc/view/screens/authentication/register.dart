import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitafit/custom_widgets/CustomTextFormField.dart';

import '../../../../settings/preferences.dart';
import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../screens.dart';

class Register extends StatefulWidget {
  const Register({
    super.key,
    required this.userSession,
    required this.authRouteNotifier,
  });

  final UserSession userSession;
  final ValueNotifier<AuthRoute> authRouteNotifier;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool obscureText = true;
  bool checkbox = false;
  String? email, password, passwordRetype;
  String? emailError, passwordError, passwordRetypeError;

  @override
  Widget build(BuildContext context) {
    return AuthenticationPage(
      userSession: widget.userSession,
      onPressedLeadingAppBar: null,
      title: 'S\'inscrire',
      subtitle: 'Inscrivez-vous pour accéder aux fonctionnalités de PansIA.',
      formKey: formKey,
      bodyChildren: [
        CustomTextFormField(
          hintText: 'Email',
          //errorText: emailError,
          //keyboardType: TextInputType.emailAddress,
          prefixIcon: AwesomeIconsLight.at,
          //textInputAction: TextInputAction.next,
          validator: Validators.validateEmail,
          onSaved: (value) => email = value,
          onChanged: (String value) {  },
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                CustomTextFormField(
                  hintText: 'Mot de passe',
                  //errorText: passwordError,
                 // keyboardType: TextInputType.visiblePassword,
                  prefixIcon: AwesomeIconsLight.lock_keyhole,
                  //textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validators.of(context).validateNotNullMinLength(
                    value: value,
                    minLength: 6,
                  ),
                  onSaved: (value) => password = value,
                  //suffixIcon: obscureText ? AwesomeIconsLight.eye_slash : AwesomeIconsLight.eye,
                  obscureText: obscureText,
                  onChanged: (String value) {  },
                  //suffixOnTap: () => setState(() => obscureText = !obscureText),
                ),
                CustomTextFormField(
                  hintText: 'Confirmez votre mot de passe',
                 // errorText: passwordRetypeError,
                  //keyboardType: TextInputType.visiblePassword,
                  prefixIcon: AwesomeIconsLight.lock_keyhole,
                  validator: Validators.validateNotNull,
                  onSaved: (value) => passwordRetype = value,
                  //suffixIcon: obscureText ? AwesomeIconsLight.eye_slash : AwesomeIconsLight.eye,
                  obscureText: obscureText,
                  onChanged: (String value) {  },
                  //suffixOnTap: () => setState(() => obscureText = !obscureText),
                  //onEditingComplete: validateSaveAndCallNext,
                ),
              ],
            );
          },
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Checkbox(
                  value: checkbox,
                  onChanged: (value) =>
                      setState(() => checkbox = value ?? false),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.sp),
                  ),
                ),
                8.widthW,
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: context.h5b1.copyWith(height: 1.5),
                      children: [
                        const TextSpan(
                          text: 'J\'accepte les ',
                        ),
                        TextSpan(
                          text: 'conditions d\'utilisation',
                          style: context.h5b1.copyWith(
                            color: context.secondary,
                            height: 1.5,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrl(
                                  Uri.parse(Preferences.cguUrl),
                                ),
                        ),
                        const TextSpan(
                          text: ' et la ',
                        ),
                        TextSpan(
                          text: 'politique de confidentialité',
                          style: context.h5b1.copyWith(
                            color: context.secondary,
                            height: 1.5,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrl(
                                  Uri.parse(Preferences.policyUrl),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
      labelAuthButton: 'S\'inscrire',
      onPressedAuthButton: next,
      normalTextSpan: 'Avez-vous déjà un compte ?',
      highlightedTextSpan: 'Se connecter',
      recognizerTextSpan: () =>
          widget.authRouteNotifier.value = AuthRoute.signin,
    );
  }

  Future<void> validateSaveAndCallNext() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await next();
  }

  Future<void> next() async {
    if (emailError.isNotNullOrEmpty ||
        passwordError.isNotNullOrEmpty ||
        passwordRetypeError.isNotNullOrEmpty) {
      setState(() {
        emailError = null;
        passwordError = null;
        passwordRetypeError = null;
      });
    }
    if (password != passwordRetype) {
      setState(() {
        passwordRetypeError = 'Veuillez confirmer votre mot de passe!';
      });
      return;
    }
    if (!checkbox) {
      context.showSnackBar(
        'Veuillez lire et accepter les conditions d\'utilisation et la politique de confidentialité!',
      );
      return;
    }
    await Dialogs.of(context).runAsyncAction(
      future: () => AuthenticationService.createUserWithEmailAndPassword(
        userSession: widget.userSession,
        email: email!,
        password: password!,
      ),
      onError: (e) {
        setState(() {
          emailError = Functions.of(context).translateException(e);
        });
      },
    );
  }
}
