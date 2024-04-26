import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../tools.dart';
import '../../../model/models_ui.dart';
import '../../dialogs.dart';
import '../../model_widgets.dart';

class ExampleFormDialog extends StatefulWidget {
  const ExampleFormDialog({
    super.key,
    required this.parentContext,
    required this.onComplete,
  });

  final BuildContext parentContext;
  final void Function(dynamic) onComplete;

  @override
  State<ExampleFormDialog> createState() => _ExampleFormDialogState();
}

class _ExampleFormDialogState extends State<ExampleFormDialog> {
  String? name;

  @override
  Widget build(BuildContext context) {
    return AdaptiveBottomSheet(
      mainAxisSize: MainAxisSize.min,
      continueButton: ModelTextButton(
        label: AppLocalizations.of(context)!.continu,
        style: context.button1style.copyWith(
          color: Colors.red,
        ),
        onPressed: () async {
          context.pop();
          Dialogs.of(widget.parentContext).runAsyncAction<dynamic>(
            future: () async {
              await Future.delayed(const Duration(seconds: 1));
              return null;
            },
            onComplete: widget.onComplete,
          );
        },
      ),
      cancelButton: ModelTextButton(
        label: AppLocalizations.of(context)!.cancel,
        onPressed: context.pop,
      ),
      children: [
        SizedBox(height: 30.sp),
        Text(
          'title',
          style: context.h1b1,
        ),
        Text(
          'Subtitle',
          textAlign: TextAlign.center,
          style: context.h5b2,
        ),
        SizedBox(height: 50.sp),
        CustomTextFormField(
          label: 'label',
          hintText: 'hint',
          prefixIcon: Icons.text_fields_sharp,
          validator: Validators.validateNotNull,
          onSaved: (value) {
            name = value;
          },
        ),
      ],
    );
  }
}
