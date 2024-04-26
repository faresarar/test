import 'package:flutter/services.dart';

import '../mvc/view/model_widgets.dart';

class TextInputFormatters {
  static TextInputFormatter cardFormatter(String sample, String separator) =>
      CustomCardFormatter(
        sample: sample,
        separator: separator,
      );

  static TextInputFormatter get phoneNumberFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'(\+)?[0-9]'));

  static TextInputFormatter get intFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  static TextInputFormatter get doubleFormatter =>
      FilteringTextInputFormatter.allow(RegExp(r'\d?((\.)([0-9]*))?'));

  static TextInputFormatter lengthFormatter(int length) =>
      LengthLimitingTextInputFormatter(length);
}
