import 'dart:ui';

import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import '../extensions/picture_extensions.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;

  const GlassmorphicCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        image: isDark
            ? "dCard2".toContainerBG()
            : "lCard4".toContainerBG(),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          // Main shadow for depth
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
          // Secondary shadow for subtle depth
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
          // Subtle top highlight for 3D effect
          BoxShadow(
            color: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : Colors.white.withValues(alpha: 0.6),
            blurRadius: 4,
            offset: const Offset(0, -1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            decoration: BoxDecoration(
              color: context.cardColor.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                width: .7,
                color: context.textColor.withValues(alpha: 0.15),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}