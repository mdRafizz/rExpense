import 'package:flutter/material.dart';
import 'package:r_expense/core/extensions/context_extension.dart';
import '../theme/text_styles.dart';

/// Extension on String to provide easy text widget creation with predefined styles
extension StringTextExtensions on String {
  /// Creates a Text widget with bodyText2 style
  Widget toBody2({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.bodyText2(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with bodyText1 style
  Widget toBody1({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.bodyText1(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with headline6 style
  Widget toHeadline6({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.headline6(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with headline5 style
  Widget toHeadline5({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.headline5(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with headline4 style
  Widget toHeadline4({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.headline4(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with headline3 style
  Widget toHeadline3({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.headline3(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with headline2 style
  Widget toHeadline2({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.headline2(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with headline1 style
  Widget toHeadline1({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.headline1(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with subtitle1 style
  Widget toSubtitle1({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.subtitle1(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  Widget toMandatoryLabel(BuildContext context, {Color? color}) {
    return Text.rich(
      TextSpan(
        text: this,
        style: TextStyles.subtitle1(color: color),
        children: [
          WidgetSpan(
            child: Transform.translate(
              offset: const Offset(0, -4),
              child: Text(
                ' *',
                style: TextStyle(color: context.buttonRedColor, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a Text widget with subtitle2 style
  Widget toSubtitle2({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.subtitle2(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with caption style
  Widget toCaption({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.caption(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with button style
  Widget toButton({Color? color, TextOverflow? overflow, int? maxLines}) {
    return Text(
      this,
      style: TextStyles.button(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with light font weight (300)
  Widget toLight({
    double fontSize = 16.0,
    Color? color,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return Text(
      this,
      style: TextStyles.light(fontSize: fontSize, color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with regular font weight (400)
  Widget toRegular({
    double fontSize = 16.0,
    Color? color,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return Text(
      this,
      style: TextStyles.regular(fontSize: fontSize, color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with medium font weight (500)
  Widget toMedium({
    double fontSize = 16.0,
    Color? color,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return Text(
      this,
      style: TextStyles.medium(fontSize: fontSize, color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with semi-bold font weight (600)
  Widget toSemiBold({
    double fontSize = 16.0,
    Color? color,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return Text(
      this,
      style: TextStyles.semiBold(fontSize: fontSize, color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  /// Creates a Text widget with bold font weight (700)
  Widget toBold({
    double fontSize = 16.0,
    Color? color,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return Text(
      this,
      style: TextStyles.bold(fontSize: fontSize, color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  String toCamelCase() {
    final words = trim().split(RegExp(r'[\s\-_]+'));
    if (words.isEmpty || words.first.isEmpty) return "";

    final camelCaseWord = words
        .map((word) {
          if (word.isEmpty) return "";
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join("");

    return camelCaseWord[0].toLowerCase() + camelCaseWord.substring(1);
  }

  Color toColor() {
    final colorInt = int.tryParse(this, radix: 16);
    return Color(0xFF000000 + colorInt! - 0xFF000000);
  }
}
