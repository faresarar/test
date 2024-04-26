import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../custom_widgets/CustomTextFormField.dart';
import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../screens.dart';

class Signin extends StatefulWidget {
  const Signin({
    super.key,
    required this.userSession,
    required this.authRouteNotifier,
  });

  final UserSession userSession;
  final ValueNotifier<AuthRoute> authRouteNotifier;

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<FormState> formKey = GlobalKey();
  bool obscureText = true;
  bool checkbox = false;
  String? email, password;
  String? emailError, passwordError;

  @override
  Widget build(BuildContext context) {
    return AuthenticationPage(
      userSession: widget.userSession,
      onPressedLeadingAppBar: null,
      title: 'Se connecter',
      subtitle: 'Connectez-vous à votre compte.',
      formKey: formKey,
      bodyChildren: [
        CustomTextFormField(
          hintText: 'Email',
          //errorText: emailError,
          //keyboardType: TextInputType.emailAddress,
          prefixIcon: AwesomeIconsLight.at,
          //textInputAction: TextInputAction.next,
          validator: Validators.validateEmail,
          onSaved: (value) => email = value, onChanged: (String value) {  },
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return CustomTextFormField(
              hintText: 'Mot de passe',
              //errorText: passwordError,
              //keyboardType: TextInputType.visiblePassword,
              prefixIcon: AwesomeIconsLight.lock_keyhole,
              validator: Validators.validateNotNull,
              onSaved: (value) => password = value,
              //suffixIcon: obscureText ? AwesomeIconsLight.eye_slash : AwesomeIconsLight.eye,
              obscureText: obscureText,
              //suffixOnTap: () => setState(() => obscureText = !obscureText),
              //onEditingComplete: validateSaveAndCallNext,
              onChanged: (String value) {  },
            );
          },
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: RichText(
            text: TextSpan(
              style: context.h5b1.copyWith(height: 1.5),
              children: [
                TextSpan(
                  text: 'Mot de passe oublié ?',
                  style: context.h5b1.copyWith(
                    color: context.secondary,
                    height: 1.5,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => context.push(
                          widget: ForgotPassword(
                            userSession: widget.userSession,
                            authRouteNotifier: widget.authRouteNotifier,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
      labelAuthButton: 'Se connecter',
      onPressedAuthButton: next,
      normalTextSpan: 'Vous n\'avez pas de compte ?',
      highlightedTextSpan: 'S\'inscrire',
      recognizerTextSpan: () =>
          widget.authRouteNotifier.value = AuthRoute.register,
    );
  }

  Future<void> validateSaveAndCallNext() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    await next();
  }

  Future<void> next() async {
    if (emailError.isNotNullOrEmpty || passwordError.isNotNullOrEmpty) {
      setState(() {
        emailError = null;
        passwordError = null;
      });
    }
    await Dialogs.of(context).runAsyncAction(
      future: () => AuthenticationService.signInWithEmailAndPassword(
        userSession: widget.userSession,
        email: email!,
        password: password!,
      ),
      onError: (e) {
        try {
          throw e;
        } on FirebaseException catch (e) {
          switch (e.code) {
            case 'weak-password':
            case 'wrong-password':
              passwordError =
                  Functions.of(context).translateExceptionKey(e.code);
              break;
            default:
              emailError = Functions.of(context).translateExceptionKey(e.code);
          }
          setState(() {});
        } catch (e) {
          setState(() {
            emailError = AppLocalizations.of(context)!.unknown_error;
          });
        }
      },
    );
  }
}
