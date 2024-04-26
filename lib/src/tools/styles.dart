import 'package:flutter/material.dart';

class Styles {
  final BuildContext context;

  Styles(this.context);

  static TextStyle poppins({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? height,
    TextOverflow? overflow,
  }) =>
      TextStyle(
        fontFamily: 'Poppins',
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        height: height,
        overflow: overflow,
      );

  static const MaterialColor primary = MaterialColor(
    0xFF3FBDB2,
    <int, Color>{
      50: Color(0xFFecf8f7),
      100: Color(0xFFd9f2f0),
      200: Color(0xFFc5ebe8),
      300: Color(0xFFb2e5e0),
      400: Color(0xFF9fded9),
      500: Color(0xFF8cd7d1),
      600: Color(0xFF79d1c9),
      700: Color(0xFF65cac1),
      800: Color(0xFF52c4ba),
      900: Color(0xFF3FBDB2),
    },
  );

  static const MaterialColor yellow = MaterialColor(
    0xFFF4C512,
    <int, Color>{
      50: Color(0xFFfef9e7),
      100: Color(0xFFfdf3d0),
      200: Color(0xFFfceeb8),
      300: Color(0xFFfbe8a0),
      400: Color(0xFFfae289),
      500: Color(0xFFf8dc71),
      600: Color(0xFFf7d659),
      700: Color(0xFFf6d141),
      800: Color(0xFFf5cb2a),
      900: Color(0xFFf4c512),
    },
  );

  static const MaterialColor green = MaterialColor(
    0xFF10CD00,
    <int, Color>{
      50: Color(0xFFe7fae6),
      100: Color(0xFFcff5cc),
      200: Color(0xFFb7f0b3),
      300: Color(0xFF9feb99),
      400: Color(0xFF88e680),
      500: Color(0xFF70e166),
      600: Color(0xFF58dc4d),
      700: Color(0xFF40d733),
      800: Color(0xFF28d21a),
      900: Color(0xFF10cd00),
    },
  );

  static const MaterialColor red = MaterialColor(
    0xFFDC3545,
    <int, Color>{
      50: Color(0xFFfcebec),
      100: Color(0xFFf8d7da),
      200: Color(0xFFf5c2c7),
      300: Color(0xFFf1aeb5),
      400: Color(0xFFee9aa2),
      500: Color(0xFFea868f),
      600: Color(0xFFe7727d),
      700: Color(0xFFe35d6a),
      800: Color(0xFFe04958),
      900: Color(0xFFDC3545),
    },
  );

  static const MaterialColor black = MaterialColor(
    0xFF0C121A,
    <int, Color>{
      50: Color(0xFFFAFAFA),
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      300: Color(0xFFE0E0E0),
      400: Color(0xFFBDBDBD),
      500: Color(0xFF9E9E9E),
      600: Color(0xFF757575),
      700: Color(0xFF616161),
      800: Color(0xFF424242),
      900: Color(0xFF0C121A),
    },
  );

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w900;
}
