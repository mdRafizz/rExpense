import 'package:flutter/material.dart';

/// A singleton class that provides theme-aware colors that automatically change
/// based on whether the current theme is light or dark, without requiring context.
class AppColor {
  static final AppColor _instance = AppColor._singleton();
  factory AppColor() => _instance;
  AppColor._singleton();

  // Default to light theme initially
  Brightness _currentBrightness = Brightness.light;
  ColorScheme _currentColorScheme = ColorScheme.light();


  // Initialize colors based on current theme
  static void initialize(BuildContext context) {
    _instance._currentBrightness = Theme.of(context).brightness;
    _instance._currentColorScheme = Theme.of(context).colorScheme;
  }

  // Update colors when theme changes
  static void updateTheme(BuildContext context) {
    _instance._currentBrightness = Theme.of(context).brightness;
    _instance._currentColorScheme = Theme.of(context).colorScheme;
  }

  // Primary colors
  static Color get primary => _instance._currentColorScheme.primary;

  static Color get secondary => _instance._currentColorScheme.secondary;

  static Color get tertiary => _instance._currentColorScheme.tertiary;

  static Color get background => _instance._currentBrightness == Brightness.light
      ? _instance._currentColorScheme.surfaceBright
      : _instance._currentColorScheme.surface;

  static Color get success => _instance._currentBrightness == Brightness.light
      ? const Color(0xFF4CAF50)
      : const Color(0xFF66BB6A);

  static Color get warning => _instance._currentBrightness == Brightness.light
      ? const Color(0xFFFFC107)
      : const Color(0xFFFFD54F);

  static Color get info => _instance._currentBrightness == Brightness.light
      ? const Color(0xFF2196F3)
      : const Color(0xFF42A5F5);


  static Color get card => _instance._currentBrightness == Brightness.light
      ? Colors.white
      : const Color(0xFF2D2D2D);

  static Color get divider => _instance._currentBrightness == Brightness.light
      ? Colors.grey.shade300
      : Colors.grey.shade700;

  static Color get error => _instance._currentColorScheme.error;

  static Color get onPrimary => _instance._currentBrightness == Brightness.light
      ? Colors.white
      : Colors.black;

  static Color get onSecondary => _instance._currentBrightness == Brightness.light
      ? Colors.white
      : Colors.black;

  static Color get onBackground => _instance._currentBrightness == Brightness.light
      ? Colors.black
      : Colors.white;

  static Color get onSurface => _instance._currentBrightness == Brightness.light
      ? Colors.black
      : Colors.white;

  static Color get onCard => _instance._currentBrightness == Brightness.light
      ? Colors.black
      : Colors.white;

  static Color get onError => _instance._currentBrightness == Brightness.light
      ? Colors.white
      : Colors.black;

  static Color customColor({
    required Color lightColor,
    required Color darkColor,
  }) {
    return _instance._currentBrightness == Brightness.light
        ? lightColor
        : darkColor;
  }

  static Brightness get brightness => _instance._currentBrightness;
  static ColorScheme get colorScheme => _instance._currentColorScheme;
}