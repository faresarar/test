import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';

import '../../../../tools.dart';
import '../../../model/enums.dart';
import '../../../model/models_ui.dart';
import '../adaptive_bottom_sheet.dart';

/// An `AdaptiveBottomSheet` as an alert dialog with a title, subtitle, icon,
/// and two buttons, used to confirm async actions, or to inform the user about
/// after an async event
class ConfirmationFutureDialog<T> extends StatelessWidget {
  const ConfirmationFutureDialog({
    super.key,
    required this.dialogState,
    this.title,
    required this.subtitle,
    required this.continueButton,
    this.cancelButton,
    this.onComplete,
    this.messageOnComplete,
    this.onError,
  });

  /// dialog state, can be `confirmation`, `success`, or `error`. it defines the
  /// color of continue button as well as the primary icon on the dialog.
  final DialogState dialogState;

  /// dialog main title
  final String? title;

  /// dialog subtitle
  final String subtitle;

  /// Continue button
  final ModelTextButton<T> continueButton;

  /// Cancel button
  final ModelTextButton? cancelButton;

  /// takes the result of the async function `onContinue` to perform a behavior.
  final void Function(T?)? onComplete;

  /// a message to show in a snackbar on completion
  final String? messageOnComplete;

  /// handle exception in `onContinue`.
  final void Function(Exception)? onError;

  @override
  Widget build(BuildContext context) {
    assert(continueButton.onPressed != null);
    Color primary = dialogState.toColorPrimary;
    LottieAnimation lottieAnimation = dialogState.toLottieAnimation;
    String dialogTitle = title ?? dialogState.toStringTitle(context);
    return AdaptiveBottomSheet(
      mainAxisSize: MainAxisSize.min,
      continueButton: ModelTextButton(
        label: continueButton.label,
        style: context.button1style.copyWith(
          color: cancelButton != null ? primary : context.b1,
        ),
        onPressed: () async {
          await Dialogs.of(context).runAsyncAction(
            future: continueButton.onPressed! as Future<T> Function(),
            onComplete: (value) {
              context.pop();
              if (onComplete != null) {
                onComplete!(value);
              }
              if (!messageOnComplete.isNullOrEmpty) {
                context.showSnackBar(messageOnComplete!);
              }
            },
            onError: onError,
            popOnError: true,
          );
        },
      ),
      cancelButton: ModelTextButton(
        label: cancelButton?.label ?? AppLocalizations.of(context)!.close,
        onPressed: () => context.pop(),
      ),
      children: [
        SizedBox(height: 30.sp),
        Center(
          child: LottieBuilder.asset(
            lottieAnimation.valueToString,
            height: 100.sp,
            width: 100.sp,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
            repeat: true,
          ),
        ),
        SizedBox(height: 45.sp),
        Text(
          dialogTitle,
          style: context.h2b1,
        ),
        SizedBox(height: 20.sp),
        SizedBox(
          height: 60.sp,
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: context.h5b2,
          ),
        ),
      ],
    );
  }
}
