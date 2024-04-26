import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app.dart';
import '../mvc/model/enums.dart';
import '../tools.dart';

extension DialogStateExtensions on DialogState {
  Color get toColorPrimary {
    switch (this) {
      case DialogState.confirmation:
        return Styles.yellow;
      case DialogState.error:
        return Styles.red;
      case DialogState.information:
      case DialogState.success:
        return primary;
      default:
        throw Exception('Value not in range');
    }
  }

  Color get toColorShade {
    switch (this) {
      case DialogState.confirmation:
        return Styles.yellow.shade50;
      case DialogState.error:
        return Styles.red.shade50;
      case DialogState.information:
      case DialogState.success:
        return Styles.primary.shade50;
      default:
        throw Exception('Value not in range');
    }
  }

  String toStringTitle(BuildContext context) {
    switch (this) {
      case DialogState.confirmation:
        return AppLocalizations.of(context)!.confirmation;
      case DialogState.information:
        return AppLocalizations.of(context)!.information;
      case DialogState.success:
        return AppLocalizations.of(context)!.great;
      case DialogState.error:
        return AppLocalizations.of(context)!.oops;
      default:
        throw Exception('Value not in range');
    }
  }

  LottieAnimation get toLottieAnimation {
    switch (this) {
      case DialogState.confirmation:
        return LottieAnimation.question;
      case DialogState.error:
      case DialogState.information:
        return LottieAnimation.error;
      case DialogState.success:
        return LottieAnimation.check;
      default:
        throw Exception('Value not in range');
    }
  }
}
