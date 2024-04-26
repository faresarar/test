import 'package:flutter/material.dart';

import '../tools/styles.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(
        fontWeight: Styles.bold,
      );

  TextStyle get semiBold => copyWith(
        fontWeight: Styles.semiBold,
      );

  TextStyle get medium => copyWith(
        fontWeight: Styles.medium,
      );

  TextStyle get regular => copyWith(
        fontWeight: Styles.regular,
      );
}
