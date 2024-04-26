import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../extensions.dart';

class Validators {
  final BuildContext context;

  Validators(this.context);

  static Validators of(BuildContext context) {
    assert(context.mounted);
    return Validators(context);
  }

  /// return `null` if [value] is a valide phone number.
  static String? validatePhoneNumber(String? value) {
    if (value.isNullOrEmpty) {
      // return AppLocalizations.of(context)!.field_required;
      return '';
    }
    if (value!.length != 8) {
      // return AppLocalizations.of(context)!.value_invalid;
      return '';
    }
    return null;
    // RegExp regExp = RegExp(
    //     r'^(((20)|(32)|(40)|(42)|(50)|(55)|(60)|(61)|(71)|(81)|(91)|(93))([0-9]{6}))|(9411[0-9]{4})$');
    // if (regExp.hasMatch(value)) {
    //   return null;
    // } else {
    //   // return AppLocalizations.of(context)!.value_invalid;
    //   return '';
    // }
  }

  /// return `null` if [value] is null, empty, or a valide phone number.
  static String? validateOptionalPhoneNumber(String? value) {
    if (value.isNullOrEmpty) {
      // return AppLocalizations.of(context)!.field_required;
      return null;
    }
    return validatePhoneNumber(value);
  }

  /// return `null` if [value] is not null or empty.
  static String? validateNotNull(String? value) {
    if (value.isNullOrEmpty) {
      // return AppLocalizations.of(context)!.field_required;
      return '';
    }
    return null;
  }

  /// return `null` if [value] is not null and it is at least [minLength] long.
  String? validateNotNullMinLength({
    required String? value,
    required int minLength,
  }) {
    if (value == null || value.isEmpty) {
      // return AppLocalizations.of(context)!.field_required;
      return '';
    } else if (value.length < minLength) {
      return AppLocalizations.of(context)!.min_caracters(minLength.toString());
    }
    return null;
  }

  /// return `null` if [value] is not null and it is a number.
  static String? validateNumberInt(String? value) {
    if (value == null || value.isEmpty) {
      // return AppLocalizations.of(context)!.field_required;
      return '';
    }
    if (int.tryParse(value) == null) {
      // return AppLocalizations.of(context)!.value_invalid;
      return '';
    }
    return null;
  }

  /// return `null` if [value] is not null and it is a valide email.
  static String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      // return AppLocalizations.of(context)!.field_required;
      return '';
    } else if (!regExp.hasMatch(value)) {
      // return AppLocalizations.of(context)!.invalid_email;
      return '';
    } else {
      return null;
    }
  }
}
