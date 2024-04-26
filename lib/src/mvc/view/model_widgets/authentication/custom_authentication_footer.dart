import 'package:flutter/material.dart';

import '../../../../tools.dart';
import '../../../controller/services.dart';
import '../../../model/models/user_session.dart';
import '../../model_widgets.dart';

class CustomAuthenticationFooter extends StatelessWidget {
  const CustomAuthenticationFooter({
    super.key,
    required this.userSession,
    required this.onAuthComplete,
  });

  final UserSession userSession;
  final void Function()? onAuthComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            14.widthW,
            Expanded(
              child: Divider(
                height: 1,
                color: context.b3,
              ),
            ),
            14.widthW,
            Text('ou continuer avec', style: context.h6b2),
            14.widthW,
            Expanded(
              child: Divider(
                height: 1,
                color: context.b3,
              ),
            ),
            14.widthW,
          ],
        ),
        44.heightH,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomFloatingFlatActionButton(
              icon: AwesomeIconsBrands.google_1,
              onPressed: () => Dialogs.of(context).runAsyncAction<void>(
                future: () => GoogleSignInService.signIn(userSession),
                onComplete: (_) {
                  if (onAuthComplete != null) {
                    onAuthComplete!();
                  }
                },
              ),
            ),
            20.widthW,
            CustomFloatingFlatActionButton(
              icon: AwesomeIconsBrands.apple_1,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
