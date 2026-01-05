import 'package:flutter/material.dart';

/// Utility class for text styles with the Fredoka font family
abstract final class TextStyles {
  // Light weight (300)
  static TextStyle light({double fontSize = 16.0, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontFamily: 'Fredoka',
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w300,
      color: color,
    );
  }

  // Regular weight (400)
  static TextStyle regular({double fontSize = 16.0, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontFamily: 'Fredoka',
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color,
    );
  }

  // Medium weight (500)
  static TextStyle medium({double fontSize = 16.0, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontFamily: 'Fredoka',
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color,
    );
  }

  // SemiBold weight (600)
  static TextStyle semiBold({double fontSize = 16.0, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontFamily: 'Fredoka',
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
    );
  }

  // Bold weight (700)
  static TextStyle bold({double fontSize = 16.0, Color? color, FontWeight? fontWeight}) {
    return TextStyle(
      fontFamily: 'Fredoka',
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color,
    );
  }

  // Headline styles
  static TextStyle headline1({Color? color}) => bold(fontSize: 36.0, color: color);
  static TextStyle headline2({Color? color}) => bold(fontSize: 32.0, color: color);
  static TextStyle headline3({Color? color}) => bold(fontSize: 28.0, color: color);
  static TextStyle headline4({Color? color}) => bold(fontSize: 24.0, color: color);
  static TextStyle headline5({Color? color}) => bold(fontSize: 20.0, color: color);
  static TextStyle headline6({Color? color}) => bold(fontSize: 18.0, color: color);

  // Subtitle styles
  static TextStyle subtitle1({Color? color}) => medium(fontSize: 16.0, color: color);
  static TextStyle subtitle2({Color? color}) => medium(fontSize: 14.0, color: color);

  // Body text styles
  static TextStyle bodyText1({Color? color}) => regular(fontSize: 16.0, color: color);
  static TextStyle bodyText2({Color? color}) => regular(fontSize: 14.0, color: color);

  // Caption style
  static TextStyle caption({Color? color}) => regular(fontSize: 12.0, color: color);

  // Button style
  static TextStyle button({Color? color}) => medium(fontSize: 14.0, color: color);
}