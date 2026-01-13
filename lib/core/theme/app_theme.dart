import 'package:flutter/material.dart';

export 'text_styles.dart';
export '../extensions/extensions.dart';
export 'app_color.dart';
export 'theme_manager.dart';

import 'package:r_expense/core/theme/app_color.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lScaffold,
      cardColor: AppColors.lCard,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lAppbar,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.lText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: "Fredoka"
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.lText),
        bodyMedium: TextStyle(color: AppColors.lText),
        bodySmall: TextStyle(color: AppColors.lText),
        headlineLarge: TextStyle(color: AppColors.lText),
        headlineMedium: TextStyle(color: AppColors.lText),
        headlineSmall: TextStyle(color: AppColors.lText),
        titleLarge: TextStyle(color: AppColors.lText),
        titleMedium: TextStyle(color: AppColors.lText),
        titleSmall: TextStyle(color: AppColors.lText),
        labelLarge: TextStyle(color: AppColors.lText),
        labelMedium: TextStyle(color: AppColors.lText),
        labelSmall: TextStyle(color: AppColors.lText),
        displayLarge: TextStyle(color: AppColors.lText),
        displayMedium: TextStyle(color: AppColors.lText),
        displaySmall: TextStyle(color: AppColors.lText),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.dScaffold,
      cardColor: AppColors.dCard,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.dAppbar,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: AppColors.dText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: "Fredoka"
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.dText),
        bodyMedium: TextStyle(color: AppColors.dText),
        bodySmall: TextStyle(color: AppColors.dText),
        headlineLarge: TextStyle(color: AppColors.dText),
        headlineMedium: TextStyle(color: AppColors.dText),
        headlineSmall: TextStyle(color: AppColors.dText),
        titleLarge: TextStyle(color: AppColors.dText),
        titleMedium: TextStyle(color: AppColors.dText),
        titleSmall: TextStyle(color: AppColors.dText),
        labelLarge: TextStyle(color: AppColors.dText),
        labelMedium: TextStyle(color: AppColors.dText),
        labelSmall: TextStyle(color: AppColors.dText),
      ),
    );
  }
}