import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../model/models/user_session.dart';
import '../.././../../tools.dart';
import '../../model_widgets.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({
    super.key,
    this.onPressedLeadingAppBar,
    required this.userSession,
    required this.title,
    required this.subtitle,
    required this.formKey,
    required this.bodyChildren,
    required this.labelAuthButton,
    required this.onPressedAuthButton,
    required this.normalTextSpan,
    required this.highlightedTextSpan,
    required this.recognizerTextSpan,
  });

  final UserSession userSession;
  final void Function()? onPressedLeadingAppBar;
  final String title;
  final String subtitle;
  final GlobalKey<FormState>? formKey;
  final List<Widget> bodyChildren;
  final String labelAuthButton;
  final Future<void> Function() onPressedAuthButton;
  final String? normalTextSpan;
  final String? highlightedTextSpan;
  final void Function()? recognizerTextSpan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: onPressedLeadingAppBar != null
            ? IconButton(
                onPressed: onPressedLeadingAppBar,
                icon: Icon(context.backButtonIcon),
              )
            : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Header
              CustomScreenHeader(
                title: title,
                subtitle: subtitle,
              ),
              //Body
              Form(
                key: formKey,
                child: SizedBox(
                  height: 400.h - context.viewPadding.bottom,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: bodyChildren,
                  ),
                ),
              ),
              //Button
              CustomAuthenticationButton(
                label: labelAuthButton,
                onPressed: () {
                  if (formKey != null) {
                    if (!formKey!.currentState!.validate()) return;
                    formKey!.currentState!.save();
                  }
                  onPressedAuthButton();
                },
                normalTextSpan: normalTextSpan,
                highlightedTextSpan: highlightedTextSpan,
                recognizerTextSpan: recognizerTextSpan,
              ),
              //Footer
              CustomAuthenticationFooter(
                userSession: userSession,
                onAuthComplete: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
