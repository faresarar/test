import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Functions {
  final BuildContext context;

  Functions(this.context);

  static Functions of(BuildContext context) {
    assert(context.mounted);
    return Functions(context);
  }

  String translateException(Exception e) {
    try {
      throw e;
    } on FirebaseException catch (e) {
      return translateExceptionKey(e.code);
    } catch (e) {
      return AppLocalizations.of(context)!.unknown_error;
    }
  }

  String translateExceptionKey(String? key) {
    if (key == null) {
      return AppLocalizations.of(context)!.unknown_error;
    }
    Map<String, dynamic> map = {
      'sign-in-canceled': AppLocalizations.of(context)!.sign_in_canceled,
      'unknown_error': AppLocalizations.of(context)!.unknown_error,
      'unavailable': AppLocalizations.of(context)!.service_unavailable,
      'time-out-being-created':
          AppLocalizations.of(context)!.time_out_being_created,
      'time-out-has-pending-writes':
          AppLocalizations.of(context)!.time_out_has_pending_writes,
      'time-out': AppLocalizations.of(context)!.time_out,
      'user-not-match': AppLocalizations.of(context)!.user_not_match,
      'account-exists-with-different-credential': AppLocalizations.of(context)!
          .account_exists_with_different_credential,
      'credential-already-in-use':
          AppLocalizations.of(context)!.credential_already_in_use,
      'email-already-in-use':
          AppLocalizations.of(context)!.email_already_in_use,
      'invalid-continue-uri':
          AppLocalizations.of(context)!.invalid_continue_uri,
      'invalid-credential': AppLocalizations.of(context)!.invalid_credential,
      'invalid-email': AppLocalizations.of(context)!.invalid_email,
      'invalid-phone-number':
          AppLocalizations.of(context)!.invalid_phone_number,
      'invalid-verification-code':
          AppLocalizations.of(context)!.invalid_verification_code,
      'invalid-verification-id':
          AppLocalizations.of(context)!.invalid_verification_id,
      'missing-android-pkg-name':
          AppLocalizations.of(context)!.missing_android_pkg_name,
      'missing-client-identifier':
          AppLocalizations.of(context)!.missing_client_identifier,
      'missing-continue-uri':
          AppLocalizations.of(context)!.missing_continue_uri,
      'missing-ios-bundle-id':
          AppLocalizations.of(context)!.missing_ios_bundle_id,
      'network-request-failed':
          AppLocalizations.of(context)!.network_request_failed,
      'operation-not-allowed':
          AppLocalizations.of(context)!.operation_not_allowed,
      'permission-denied': AppLocalizations.of(context)!.permission_denied,
      'provider-already-linked':
          AppLocalizations.of(context)!.provider_already_linked,
      'quota-exceeded': AppLocalizations.of(context)!.quota_exceeded,
      'requires-recent-login':
          AppLocalizations.of(context)!.requires_recent_login,
      'too-many-requests': AppLocalizations.of(context)!.too_many_requests,
      'unauthorized-continue-uri':
          AppLocalizations.of(context)!.unauthorized_continue_uri,
      'user-disabled': AppLocalizations.of(context)!.user_disabled,
      'user-mismatch': AppLocalizations.of(context)!.user_mismatch,
      'user-not-found': AppLocalizations.of(context)!.user_not_found,
      'weak-password': AppLocalizations.of(context)!.weak_password,
      'wrong-password': AppLocalizations.of(context)!.wrong_password,
      'app-not-authorized': AppLocalizations.of(context)!.app_not_authorized,
    };
    String? errorMessage = map[key];
    if (errorMessage == null) {
      log('Error: key $key not found in error codes map, please check');
    }
    return errorMessage ?? key;
  }

  ///Merge two iterables [a] and [b] into one. Mainly used to create a `TextSpam`
  ///for `RichText` widget from the result, after splitting a String and applying the appropriate text style on the matches of a RegExp.
  static Iterable<T> zip<T>(Iterable<T> a, Iterable<T> b) sync* {
    final ita = a.iterator;
    final itb = b.iterator;
    bool hasa, hasb;
    while ((hasa = ita.moveNext()) | (hasb = itb.moveNext())) {
      if (hasa) yield ita.current;
      if (hasb) yield itb.current;
    }
  }
}
