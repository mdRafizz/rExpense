import 'package:flutter/material.dart';

/// Centralized color palette for the rexpense design system.
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A42CC);

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color income = Color(0xFF43B89C);
  static const Color expense = Color(0xFFFF6584);
  static const Color warning = Color(0xFFFFBE0B);
  static const Color danger = Color(0xFFEF476F);
  static const Color success = Color(0xFF06D6A0);

  // ── Neutrals (Light) ───────────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFEEEFF5);
  static const Color textPrimaryLight = Color(0xFF1A1D2E);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textTertiaryLight = Color(0xFFB0B7C3);

  // ── Neutrals (Dark) ────────────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0F1117);
  static const Color surfaceDark = Color(0xFF1A1D2E);
  static const Color cardDark = Color(0xFF242736);
  static const Color dividerDark = Color(0xFF2E3147);
  static const Color textPrimaryDark = Color(0xFFF1F2F8);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textTertiaryDark = Color(0xFF4B5563);

  // ── Category palette ───────────────────────────────────────────────────────
  static const List<Color> categoryPalette = [
    Color(0xFF6C63FF),
    Color(0xFF43B89C),
    Color(0xFFFF6584),
    Color(0xFFFFBE0B),
    Color(0xFF3A86FF),
    Color(0xFFFF9F1C),
    Color(0xFF8338EC),
    Color(0xFF06D6A0),
    Color(0xFFEF476F),
    Color(0xFF118AB2),
  ];
}
