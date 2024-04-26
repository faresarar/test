import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/enums.dart';
import '../../../model/models.dart';
import '../../screens.dart';

class AccountActivation extends StatefulWidget {
  const AccountActivation({
    super.key,
    required this.userSession,
    required this.authRouteNotifier,
  });

  final UserSession userSession;
  final ValueNotifier<AuthRoute> authRouteNotifier;

  @override
  State<AccountActivation> createState() => _AccountActivationState();
}

class _AccountActivationState extends State<AccountActivation> {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? email;

  @override
  Widget build(BuildContext context) {
    return AuthenticationPage(
      userSession: widget.userSession,
      onPressedLeadingAppBar: () => Dialogs.of(context).runAsyncAction(
        future: widget.userSession.signOut,
        onComplete: (_) {
          widget.authRouteNotifier.value = AuthRoute.signin;
        },
      ),
      title: 'E-mail envoyé',
      subtitle: 'Nous vous avons envoyé un lien d\'activation par e-mail.',
      formKey: formKey,
      bodyChildren: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: context.h5b1.copyWith(height: 1.5),
              children: [
                TextSpan(
                  text: 'Vous n\'avez pas reçu le lien d\'activation ? ',
                  recognizer: TapGestureRecognizer()
                    ..onTap = resendActivationEmail,
                ),
                TextSpan(
                  text: 'Renvoyer',
                  style: context.h5b1.copyWith(
                    color: context.secondary,
                    height: 1.5,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = resendActivationEmail,
                ),
              ],
            ),
          ),
        ),
      ],
      labelAuthButton: 'Continuer',
      onPressedAuthButton: () => Dialogs.of(context).runAsyncAction(
        future: widget.userSession.refreshisEmailVerified,
        onComplete: (_) {
          if (widget.userSession.emailVerified == false) {
            context.showSnackBar(
                'Veuillez activer votre compte en utilisant le lien envoyé à votre email.');
          }
        },
      ),
      normalTextSpan: null,
      highlightedTextSpan: null,
      recognizerTextSpan: null,
    );
  }

  Future<void> resendActivationEmail() async {
    await Dialogs.of(context).runAsyncAction(
      future: AuthenticationService.sendEmailVerification,
      onCompleteMessage:
          'Nous vous avons envoyé un lien d\'activation par e-mail.',
      dialogType: DialogType.snackbar,
    );
  }
}
