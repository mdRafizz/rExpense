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
    // Original 10
    Color(0xFF6C63FF), // Purple
    Color(0xFF43B89C), // Teal
    Color(0xFFFF6584), // Pink
    Color(0xFFFFBE0B), // Yellow
    Color(0xFF3A86FF), // Blue
    Color(0xFFFF9F1C), // Orange
    Color(0xFF8338EC), // Violet
    Color(0xFF06D6A0), // Mint
    Color(0xFFEF476F), // Rose
    Color(0xFF118AB2), // Cerulean

    // Daily Essentials — warm amber/earthy
    Color(0xFFE07B39), // Warm Amber
    Color(0xFFD4A017), // Golden Wheat

    // Protein — deep reds/meaty tones
    Color(0xFFC0392B), // Meat Red
    Color(0xFF6B3A2A), // Smoky Brown

    // Bills & Utilities — electric blues/grays
    Color(0xFF1A73E8), // Electric Blue
    Color(0xFF546E7A), // Slate Gray

    // Finance — rich greens/golds
    Color(0xFF2E7D32), // Money Green
    Color(0xFFB8860B), // Dark Gold

    // Health — clean teals/medical greens
    Color(0xFF00897B), // Medical Teal
    Color(0xFF7CB342), // Healthy Green

    // Shopping — vibrant magentas/pinks
    Color(0xFFD81B60), // Shopping Pink
    Color(0xFFAD1457), // Deep Magenta

    // Education — academic blues/navies
    Color(0xFF1565C0), // Academic Blue
    Color(0xFF283593), // Deep Navy

    // Entertainment — vivid purples/corals
    Color(0xFF7B1FA2), // Cinema Purple
    Color(0xFFFF5252), // Vivid Coral

    // Travel — sky blues/adventure teals
    Color(0xFF039BE5), // Sky Blue
    Color(0xFF00ACC1), // Ocean Teal

    // Social & Family — warm rose/gift reds
    Color(0xFFE91E63), // Family Rose
    Color(0xFFFF6F00), // Gift Orange

    // Personal — soft lavenders/spa tones
    Color(0xFF9575CD), // Lavender
    Color(0xFF80DEEA), // Spa Cyan

    // Home & Maintenance — earthy neutrals/tool grays
    Color(0xFF795548), // Wood Brown
    Color(0xFF78909C), // Tool Gray

    // Others — neutral purples/muted tones
    Color(0xFF90A4AE), // Muted Blue-Gray
    Color(0xFFBCAAA4), // Warm Taupe
  ];
}
