import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../mvc/model/enums.dart';
import '../mvc/model/models_ui.dart';
import '../mvc/view/dialogs.dart';
import '../mvc/view/model_widgets.dart';
import '../tools.dart';

class Dialogs {
  final BuildContext context;

  Dialogs(this.context);

  static Dialogs of(BuildContext context) {
    assert(context.mounted);
    return Dialogs(context);
  }

  /// Shows a custom alert dialog, adaptive to screen size and also to dialog content.
  /// - [dialogState] : dialog type. It defaults to `DialogState.confirmation` if null.
  /// - [title] : dialog title. It defaults to `Confirmation` if null.
  /// - [subtitle] : dialog subtitle.
  /// - [continueLabel] : dialog main button label. It defaults to `Continue` if null.
  /// - [onContinue] : dialog main button onPressed behavior label.
  Future<void> showAlertDialog({
    DialogState? dialogState,
    String? title,
    required String subtitle,
    String? continueLabel,
    required void Function() onContinue,
  }) async {
    await context.showAdaptiveModalBottomSheet(
      builder: (_) => ConfirmationDialog(
        dialogState: dialogState ?? DialogState.confirmation,
        title: title,
        subtitle: subtitle,
        continueButton: ModelTextButton(
          label: continueLabel ?? AppLocalizations.of(context)!.yes,
          onPressed: onContinue,
        ),
        cancelButton: ModelTextButton(
          label: AppLocalizations.of(context)!.cancel,
        ),
      ),
    );
  }

  Future<void> showUpdateVersionDialog({
    required String title,
    required String subtitle,
    required String label,
    required void Function() onContionue,
  }) async {
    await context.showAdaptiveModalBottomSheet(
      isDismissible: false,
      builder: (_) => ConfirmationDialog(
        dialogState: DialogState.information,
        title: title,
        subtitle: subtitle,
        continueButton: ModelTextButton(
          label: label,
          onPressed: onContionue,
        ),
        cancelButton: null,
        autoPop: false,
      ),
    );
  }

  /// Shows a custom async alert dialog, adaptive to screen size and also to dialog content.
  /// Async meaning that we should show a loading indicator while waiting for onContinue to finish.
  /// - [dialogState] : dialog type. It defaults to `DialogState.confirmation` if null.
  /// - [title] : dialog title. It defaults to `Confirmation` if null.
  /// - [subtitle] : dialog subtitle.
  /// - [continueLabel] : dialog main button label.
  /// - [future] : dialog main button onPressed behavior label.
  /// - [onComplete] : execute this function after `future`.
  /// - [onError] : execute this function on `Exception` in `future`.
  /// - [messageOnComplete] : a message for snackbar to show after `onComplete`.
  Future<void> showAsyncAlertDialog<T>({
    DialogState? dialogState,
    String? title,
    required String subtitle,
    required String continueLabel,
    required Future<T> Function() future,
    void Function(T?)? onComplete,
    required String? messageOnComplete,
    void Function(Exception)? onError,
  }) async {
    await context.showAdaptiveModalBottomSheet(
      builder: (_) => ConfirmationFutureDialog(
        dialogState: dialogState ?? DialogState.confirmation,
        title: title,
        subtitle: subtitle,
        continueButton: ModelTextButton(
          label: continueLabel,
          onPressed: future,
        ),
        cancelButton: ModelTextButton(
          label: AppLocalizations.of(context)!.cancel,
        ),
        onComplete: onComplete,
        messageOnComplete: messageOnComplete,
        onError: onError,
      ),
    );
  }

  /// Show an alert adaptive dialog.
  /// - [isDismissible] : if `true, the dialog shouw be dissmisible by swiping down.
  /// - [enableDrag] : if `true, the dialog shouw be dragable.
  /// - [onComplete] : Execute after the dialog is dissmised.
  Future<void> showAdaptiveModalBottomSheet({
    required Widget Function(BuildContext) builder,
    bool isDismissible = true,
    bool enableDrag = true,
    void Function()? onComplete,
  }) async {
    await showModalBottomSheet(
      elevation: 0,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      context: context,
      builder: builder,
    ).whenComplete(onComplete ?? () {});
  }

  /// Show a dialog as a leading indicator.
  /// This dialog is used to block any user inputs until an async function finished.
  Future<void> showLoadingIndicator() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const PopScope(
        canPop: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomLoadingIndicator(
              margin: EdgeInsets.zero,
              isSliver: false,
            )
          ],
        ),
      ),
    );
  }

  /// Show the loading indicator while waiting for [future] function to finish.
  /// - [future] : An async funtion.
  /// - [onComplete] : Executre this function when `future` is finished.
  /// - [onCompleteMessage] : show this message in a snackbar after `onComplete`.
  /// - [onError] : Execute on `Exception` in `future`.
  /// - [popOnError] : if `true`, pop the parent widget with `context` and close the screen.
  Future<T?> runAsyncAction<T>({
    required Future<T?> Function() future,
    void Function(T?)? onComplete,
    void Function(Exception)? onError,
    bool popOnError = false,
    String? onCompleteMessage,
    DialogType dialogType = DialogType.bottomsheet,
  }) async {
    try {
      showLoadingIndicator();
      return await future().then(
        (result) {
          if (!context.mounted) {
            if (kDebugMode) {
              throw Exception('Context is no longer mounted');
            } else {
              return null;
            }
          }
          context.pop();
          if (onComplete != null) {
            onComplete(result);
          }
          if (!onCompleteMessage.isNullOrEmpty) {
            switch (dialogType) {
              case DialogType.bottomsheet:
                context.showAdaptiveModalBottomSheet(
                  builder: (_) => ConfirmationDialog(
                    dialogState: DialogState.success,
                    subtitle: onCompleteMessage!,
                    continueButton: ModelTextButton(
                        label: AppLocalizations.of(context)!.close),
                  ),
                );
                break;
              case DialogType.snackbar:
                context.showSnackBar(
                  onCompleteMessage!,
                );
                break;
              default:
                throw UnimplementedError();
            }
          }
          return result;
        },
      );
    } on Exception catch (e) {
      if (!context.mounted) {
        if (kDebugMode) {
          throw Exception('Context is no longer mounted');
        } else {
          return null;
        }
      }
      //pop loading widget
      context.pop();
      if (popOnError) {
        //if there is a dialog hehind, pop it
        context.pop();
      }
      if (onError != null) {
        onError(e);
      } else {
        if (kDebugMode) {
          print(e);
        }
        late String errorMessage;
        try {
          rethrow;
        } on FirebaseException catch (e) {
          errorMessage = Functions.of(context).translateExceptionKey(e.code);
        } catch (e) {
          errorMessage = AppLocalizations.of(context)!.unknown_error;
        }
        switch (dialogType) {
          case DialogType.bottomsheet:
            context.showAdaptiveModalBottomSheet(
              builder: (_) => ConfirmationDialog(
                dialogState: DialogState.error,
                subtitle: errorMessage,
                continueButton:
                    ModelTextButton(label: AppLocalizations.of(context)!.close),
              ),
            );
            break;
          case DialogType.snackbar:
            context.showSnackBar(
              errorMessage,
            );
            break;
          default:
            throw UnimplementedError();
        }
      }
      return null;
    }
  }

  /// Show a dialog configured specifically for alerting the user to grant use of a permission.
  /// - [title] : dialog title.
  /// - [subtitle] : dialog subtitle.
  /// - [barrierDismissible] : if `true`, the dialog will be dissmisable by swiping down.
  Future<void> showPermissionDialog({
    required String title,
    required String subtitle,
    bool barrierDismissible = true,
    required AppSettingsType? appSettingsType,
  }) async {
    await context.showAdaptiveModalBottomSheet(
      builder: (_) => ConfirmationDialog(
        dialogState: DialogState.confirmation,
        title: title,
        subtitle: subtitle,
        continueButton: appSettingsType == null
            ? ModelTextButton(
                label: AppLocalizations.of(context)!.close,
              )
            : ModelTextButton(
                label: AppLocalizations.of(context)!.open_settings,
                style: context.button1style.copyWith(
                  color: context.primary,
                ),
                onPressed: () => AppSettings.openAppSettings(
                  type: appSettingsType,
                ),
              ),
        cancelButton: appSettingsType != null
            ? ModelTextButton(
                label: AppLocalizations.of(context)!.close,
              )
            : null,
      ),
    );
  }

  /// Handle backend [exception] and show an adaptive dialog explaining the problem.
  Future<void> handleBackendException({
    required Exception exception,
  }) async {
    // await context.showAdaptiveModalBottomSheet(
    //   builder: (_) => ConfirmationDialog(
    //     dialogState: DialogState.error,
    //     subtitle: exception is BookingHeroException
    //         ? exception.message
    //         : AppLocalizations.of(context)!.unknown_error,
    //     continueLabel: AppLocalizations.of(context)!.ignore_close,
    //     onContinue: null,
    //   ),
    // );
  }

  /// Shows a value picker dialog with
  /// dialog [title],
  /// [values] to pick one from,
  /// [initialvalue] initial picked value,
  /// [onPick] behavior
  /// [hintText] search text field hint,
  /// [searchable] if `true`, show a text field to search the values.
  /// [searchStartsWith]
  ///   - if `true`, search values and return those that start with the quesry test.
  ///   - if `false`, search values and return those that contain quesry test.
  Future<void> showSingleValuePickerDialog({
    required String title,
    required List<String> values,
    required String? initialvalue,
    String? hintText,
    bool searchable = false,
    bool searchStartsWith = false,
    required void Function(String) onPick,
  }) async {
    await context.showAdaptiveModalBottomSheet(
      builder: (context) => SingleValuePickerDialog(
        title: title,
        hintText: hintText,
        values: values,
        searchable: searchable,
        searchStartsWith: searchStartsWith,
        initialValue: initialvalue,
        mainAxisSize: MainAxisSize.min,
        physics: const ClampingScrollPhysics(),
        onPick: onPick,
      ),
    );
  }

  Future<void> showExampleFormDialog({
    required void Function(dynamic) onComplete,
  }) async {
    await context.showAdaptiveModalBottomSheet(
      builder: (_) => ExampleFormDialog(
        parentContext: context,
        onComplete: onComplete,
      ),
    );
  }

  Future<void> showMenuDialog(List<ModelTextButton> items) async {
    await context.showAdaptiveModalBottomSheet(
      builder: (_) => MenuDialog(items: items),
    );
  }
}
