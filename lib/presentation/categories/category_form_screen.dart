import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/category/category_cubit.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/category.dart';

/// Available icons for categories (Material icon codepoints).
const _kCategoryIcons = [
  ('e56c', 'Restaurant'),
  ('e531', 'Car'),
  ('e8cc', 'Shopping'),
  ('e02c', 'Movie'),
  ('e548', 'Health'),
  ('e541', 'Coffee'),
  ('e227', 'Wallet'),
  ('e1ff', 'Home'),
  ('e7fd', 'Person'),
  ('e8f9', 'Work'),
  ('e8b8', 'School'),
  ('e87d', 'Fitness'),
  ('e899', 'Music'),
  ('e332', 'Flight'),
  ('e5d5', 'Hotel'),
  ('e8d1', 'Star'),
];

class CategoryFormScreen extends StatefulWidget {
  final Category? category;

  const CategoryFormScreen({super.key, this.category});

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late int _selectedColor;
  late String _selectedIcon;
  late bool _isUnnecessary;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.category?.color ??
        AppColors.categoryPalette[0].toARGB32();
    _selectedIcon = widget.category?.icon ?? _kCategoryIcons[0].$1;
    _isUnnecessary = widget.category?.isUnnecessary ?? false;
    if (_isEditing) {
      _nameController.text = widget.category!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<CategoryCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Category' : 'New Category'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ── Preview ──────────────────────────────────────────────────
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Color(_selectedColor).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Icon(
                      IconData(
                        int.parse(_selectedIcon, radix: 16),
                        fontFamily: 'MaterialIcons',
                      ),
                      color: Color(_selectedColor),
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Name ─────────────────────────────────────────────────────
              Text('Name', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Category name'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: 24),

              // ── Color ─────────────────────────────────────────────────────
              Text('Color', style: AppTextStyles.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: AppColors.categoryPalette.map((color) {
                  final isSelected = color.toARGB32() == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color.toARGB32()),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2.5,
                              )
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // ── Icon ──────────────────────────────────────────────────────
              Text('Icon', style: AppTextStyles.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _kCategoryIcons.map((iconData) {
                  final isSelected = iconData.$1 == _selectedIcon;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedIcon = iconData.$1),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(_selectedColor).withValues(alpha: 0.15)
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected
                            ? Border.all(
                                color: Color(_selectedColor),
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          IconData(
                            int.parse(iconData.$1, radix: 16),
                            fontFamily: 'MaterialIcons',
                          ),
                          color: isSelected
                              ? Color(_selectedColor)
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 22,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // ── Unnecessary toggle ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Track as Unnecessary',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Enables spending-leak alerts for this category',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isUnnecessary,
                      onChanged: (v) => setState(() => _isUnnecessary = v),
                      activeTrackColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Submit ────────────────────────────────────────────────────
              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () => _submit(context),
                    child: Text(_isEditing ? 'Update Category' : 'Create Category'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<CategoryCubit>();

    if (_isEditing) {
      await cubit.updateCategory(
        widget.category!.copyWith(
          name: _nameController.text.trim(),
          color: _selectedColor,
          icon: _selectedIcon,
          isUnnecessary: _isUnnecessary,
        ),
      );
    } else {
      await cubit.createCategory(
        name: _nameController.text.trim(),
        color: _selectedColor,
        icon: _selectedIcon,
        isUnnecessary: _isUnnecessary,
      );
    }

    if (context.mounted) context.pop();
  }
}
