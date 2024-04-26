import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../tools.dart';
import '../../../model/change_notifiers.dart';
import '../../../model/models_ui.dart';
import '../../dialogs.dart';
import '../../model_widgets.dart';

/// An `AdaptiveBottomSheet` to display options the user can pick multiple values from.
class MultiValuePickerDialog extends StatelessWidget {
  const MultiValuePickerDialog({
    super.key,
    required this.title,
    required this.values,
    required this.initialValues,
    this.hintText,
    this.searchable = false,
    this.searchStartsWith = false,
    required this.physics,
    required this.onPick,
    required this.mainAxisSize,
  }) : assert((!searchable && !searchStartsWith && hintText == null) ||
            searchable);

  /// Dialog title
  final String title;

  /// options
  final List<String> values;

  /// initial picked values
  final List<String> initialValues;

  /// Search text field hint
  final String? hintText;

  ///   - if `true`, search values and return those that start with the quesry test.
  ///   - if `false`, search values and return those that contain quesry test.
  final bool searchable;

  /// Used to configure how options are filtered during search for quick access:
  /// - if `true`: filter options that start with the search input text,
  /// - if `false`: filter options that contain the search input text,
  final bool searchStartsWith;

  /// scroll behavior
  final ScrollPhysics physics;

  /// on pick values, specifically a list of `String`
  final void Function(List<String>) onPick;

  /// defines the size of the bottom sheet, MainAxisSize.max to take full screen,
  /// of MainAxisSize.min to take only part of the screen.
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    List<String> pickedValues = [];
    pickedValues.addAll(initialValues);
    NotifierString searchNotifier = NotifierString('');
    return AdaptiveBottomSheet(
      mainAxisSize: mainAxisSize,
      continueButton: ModelTextButton(
        label: AppLocalizations.of(context)!.continu,
        style: context.button1style.copyWith(
          color: context.primary,
        ),
        onPressed: () async {
          context.pop();
          onPick(pickedValues);
        },
      ),
      cancelButton: ModelTextButton(
        label: AppLocalizations.of(context)!.close,
        style: context.button1style.copyWith(
          color: Styles.red,
        ),
        onPressed: () => context.pop(),
      ),
      children: [
        Text(
          title,
          style: context.h3b1,
        ),
        SizedBox(height: 20.sp),
        if (searchable)
          CustomTextFormField(
            hintText: hintText,
            prefixIcon: AwesomeIconsLight.magnifying_glass,
            fillColor: context.primaryColor[50],
            prefixColor: context.primary,
            onChanged: (value) {
              searchNotifier.setValue(value.toLowerCase());
            },
          ),
        ValueListenableBuilder(
          valueListenable: searchNotifier,
          builder: (context, search, _) {
            RegExp pattern =
                searchStartsWith ? RegExp(r'^' + search) : RegExp(r'' + search);
            Iterable<String> elements = values
                .where((element) => pattern.hasMatch(element.toLowerCase()));
            return StatefulBuilder(
              builder: (context, setState) {
                var container = Container(
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        context.scaffoldBackgroundColor,
                        context.scaffoldBackgroundColor.withOpacity(0),
                        context.scaffoldBackgroundColor.withOpacity(0),
                        context.scaffoldBackgroundColor
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0.1, 0.85, 1],
                    ),
                  ),
                  child: ListView.separated(
                    physics: physics,
                    padding: EdgeInsetsDirectional.fromSTEB(
                      10.w,
                      20.h,
                      0,
                      0,
                    ),
                    itemBuilder: (context, index) => CustomCheckBox(
                      value: pickedValues.contains(elements.elementAt(index)),
                      label: elements.elementAt(index),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          if (index == 0 && elements.elementAt(0) == 'All') {
                            if (value) {
                              pickedValues.addAll(values);
                            } else {
                              pickedValues.clear();
                            }
                          } else {
                            if (value) {
                              pickedValues.add(values.elementAt(index));
                              if (pickedValues.length == values.length - 1 &&
                                  values.contains(
                                      AppLocalizations.of(context)!.all)) {
                                pickedValues
                                    .add(AppLocalizations.of(context)!.all);
                              }
                            } else {
                              pickedValues.remove(values.elementAt(index));
                              pickedValues
                                  .remove(AppLocalizations.of(context)!.all);
                            }
                          }
                        });
                      },
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox.shrink(),
                    itemCount: elements.length,
                  ),
                );
                if (mainAxisSize == MainAxisSize.max) {
                  return Expanded(
                    child: container,
                  );
                } else {
                  return container;
                }
              },
            );
          },
        ),
      ],
    );
  }
}
