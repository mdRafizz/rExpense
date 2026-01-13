import 'package:flutter/material.dart';

import '../theme/app_color.dart';

extension ContextExtension on BuildContext {
  // Brightness
  Brightness get brightness => Theme.brightnessOf(this);

  // Check if the current theme is dark
  bool get isDarkMode => brightness == Brightness.dark;

  Brightness get inverseBrightness => brightness == Brightness.dark ? Brightness.light : Brightness.dark;


  // Dynamic Scaffold Color
  Color get scaffoldColor => isDarkMode ? AppColors.dScaffold : AppColors.lScaffold;

  // Dynamic Appbar Color
  Color get appbarColor => isDarkMode ? AppColors.dAppbar : AppColors.lAppbar;

  // Dynamic Card Color
  Color get cardColor => isDarkMode ? AppColors.dCard : AppColors.lCard;

  // Dynamic Text Color
  Color get textColor => isDarkMode ? AppColors.dText : AppColors.lText;

  // Dynamic Divider Color
  Color get dividerColor => isDarkMode ? AppColors.dDivider : AppColors.lDivider;

  // Dynamic Button Color
  Color get buttonRedColor => isDarkMode?AppColors.dButtonRed: AppColors.lButtonRed;
  Color get buttonGreenColor => isDarkMode?AppColors.dButtonGreen: AppColors.lButtonGreen;

  // Dynamic TextField Color
  Color get textFieldColor => isDarkMode ? AppColors.dTextField : AppColors.lTextField;



  // Custom Color Logic Example
  Color get brandColor => isDarkMode ? Colors.blueAccent : Colors.blue;
}