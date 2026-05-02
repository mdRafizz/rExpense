import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../core/theme/app_text_styles.dart';

/// A compact chip displaying a category's icon and name.
class CategoryChip extends StatelessWidget {
  final Category category;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category.color);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.15)
              : (isDark
                  ? const Color(0xFF242736)
                  : const Color(0xFFF5F6FC)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconData(
                int.parse(category.icon, radix: 16),
                fontFamily: 'MaterialIcons',
              ),
              color: color,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              category.name,
              style: AppTextStyles.labelMedium.copyWith(
                color: selected
                    ? color
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
