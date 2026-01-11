import 'package:flutter/material.dart';

import '../theme/app_color.dart';

extension ContextExtension on BuildContext {
  // Check if the current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Dynamic Scaffold Color
  Color get scaffoldColor => isDarkMode ? AppColors.dScaffold : AppColors.lScaffold;

  // Dynamic Card Color
  Color get cardColor => isDarkMode ? AppColors.dCard : AppColors.lCard;

  // Dynamic Text Color
  Color get textColor => isDarkMode ? AppColors.dText : AppColors.lText;

  // Dynamic Divider Color
  Color get dividerColor => isDarkMode ? AppColors.dDivider : AppColors.lDivider;

  // Dynamic Button Color
  Color get buttonRedColor => isDarkMode?AppColors.dButtonRed: AppColors.lButtonRed;
  Color get buttonGreenColor => isDarkMode?AppColors.dButtonGreen: AppColors.lButtonGreen;


  // Custom Color Logic Example
  Color get brandColor => isDarkMode ? Colors.blueAccent : Colors.blue;
}