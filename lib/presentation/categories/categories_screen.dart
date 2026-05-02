import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/category/category_cubit.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/category.dart';
import '../widgets/category_icon_widget.dart';

/// Sub-labels shown under each category name to clarify what it covers.
const _kSubLabels = <String, String>{
  'cat_groceries':     'Vegetables, fruits, daily items',
  'cat_medicine':      'Drugs, pharmacy',
  'cat_food':          'Restaurants, takeaway, snacks',
  'cat_transport':     'Bus, rickshaw, fuel, ride-share',
  'cat_protein':       'Meat, fish, beef, chicken',
  'cat_egg':           'Eggs (tracked separately)',
  'cat_meat':          'Beef, mutton, fish, chicken',
  'cat_staples':       'Rice, ata, flour, oil, dal',
  'cat_electricity':   'Electric bill (tracked separately)',
  'cat_rent':          'House / office rent',
  'cat_internet':      'Broadband, WiFi bill',
  'cat_mobile':        'Mobile recharge, data',
  'cat_utilities':     'Gas, water, waste, misc bills',
  'cat_lend':          'Money given to someone',
  'cat_borrow':        'Money taken from someone',
  'cat_salary':        'Income, wages, freelance',
  'cat_subscription':  'Netflix, Spotify, SaaS, apps',
  'cat_health':        'Doctor visits, tests, hospital',
  'cat_shopping':      'Clothes, shoes, random buys',
  'cat_entertainment': 'Movies, games, outings',
  'cat_personal':      'Self-care, grooming, misc',
  'cat_education':     'School, tuition, books, courses',
  'cat_travel':        'Trips, hotels, tickets',
  'cat_family':        'Family shared expenses',
  'cat_gift':          'Gifts, presents',
  'cat_charity':       'Donations, sadaqah, zakat',
  'cat_maintenance':   'Home repair, plumbing, painting',
  'cat_others':        'Anything that doesn\'t fit above',
};

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<CategoryCubit>(),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatelessWidget {
  const _CategoriesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New category',
            onPressed: () => context.push('/categories/new'),
          ),
        ],
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) => switch (state) {
          CategoryLoading() =>
            const Center(child: CircularProgressIndicator()),
          CategoryError(:final message) => Center(child: Text(message)),
          CategoryLoaded(:final categories) =>
            _CategoryList(categories: categories),
        },
      ),
    );
  }
}

// ── List ──────────────────────────────────────────────────────────────────────

class _CategoryList extends StatelessWidget {
  final List<Category> categories;
  const _CategoryList({required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined,
                size: 64,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text('No categories yet',
                style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.4))),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _CategoryTile(category: categories[i]),
    );
  }
}

// ── Tile ──────────────────────────────────────────────────────────────────────

class _CategoryTile extends StatelessWidget {
  final Category category;
  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = Color(category.color);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subLabel = _kSubLabels[category.id];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: _iconWidget(category.icon, color),
            ),
          ),
          const SizedBox(width: 14),

          // Name + sub-label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                if (subLabel != null) ...[
                  const SizedBox(height: 2),
                  Text(subLabel, style: AppTextStyles.labelSmall),
                ],
                if (category.isUnnecessary) ...[
                  const SizedBox(height: 2),
                  Text(
                    '⚠ Spending leak tracking on',
                    style: AppTextStyles.labelSmall
                        .copyWith(color: AppColors.warning),
                  ),
                ],
              ],
            ),
          ),

          // Edit
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: () =>
                context.push('/categories/edit', extra: category),
          ),

          // Delete
          IconButton(
            icon: const Icon(Icons.delete_outline,
                size: 18, color: AppColors.danger),
            onPressed: () => _confirmDelete(context, category),
          ),
        ],
      ),
    );
  }

  /// Render the category icon — supports both emoji strings and legacy
  /// Material icon hex codepoints.
  Widget _iconWidget(String icon, Color color) =>
      buildCategoryIcon(icon, color: color, size: 20);

  Future<void> _confirmDelete(BuildContext context, Category cat) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text(
          'Delete "${cat.name}"? Transactions in this category '
          'will lose their category link.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<CategoryCubit>().deleteCategory(cat.id);
    }
  }
}
