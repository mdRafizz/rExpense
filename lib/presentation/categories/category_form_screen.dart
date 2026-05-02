import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../application/category/category_cubit.dart';
import '../../application/member/member_cubit.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/category.dart';

// ── Emoji icon catalogue ──────────────────────────────────────────────────────
// Each entry: (emoji, label, group)
// The `icon` field in Category stores the emoji string directly.

class _EmojiDef {
  final String emoji;
  final String label;
  const _EmojiDef(this.emoji, this.label);
}

class _EmojiGroup {
  final String title;
  final List<_EmojiDef> items;
  const _EmojiGroup(this.title, this.items);
}

const _kEmojiGroups = [
  _EmojiGroup('Daily Essentials', [
    _EmojiDef('🛒', 'Groceries'),
    _EmojiDef('💊', 'Medicine'),
    _EmojiDef('🍽️', 'Food'),
    _EmojiDef('🚌', 'Transport'),
    _EmojiDef('🥚', 'Egg'),
    _EmojiDef('🌾', 'Staples'),
  ]),
  _EmojiGroup('Protein', [
    _EmojiDef('🥩', 'Meat'),
    _EmojiDef('🐟', 'Fish'),
    _EmojiDef('🐄', 'Beef'),
    _EmojiDef('🍗', 'Chicken'),
    _EmojiDef('🥚', 'Egg'),
    _EmojiDef('🍳', 'Protein'),
  ]),
  _EmojiGroup('Bills & Utilities', [
    _EmojiDef('⚡', 'Electricity'),
    _EmojiDef('🏠', 'Rent'),
    _EmojiDef('📶', 'Internet'),
    _EmojiDef('📱', 'Mobile'),
    _EmojiDef('💧', 'Water'),
    _EmojiDef('🔧', 'Utilities'),
    _EmojiDef('🔥', 'Gas'),
  ]),
  _EmojiGroup('Finance', [
    _EmojiDef('💸', 'Lend'),
    _EmojiDef('🤝', 'Borrow'),
    _EmojiDef('💰', 'Salary'),
    _EmojiDef('🔄', 'Subscription'),
    _EmojiDef('🏦', 'Bank'),
    _EmojiDef('💳', 'Card'),
  ]),
  _EmojiGroup('Health', [
    _EmojiDef('🏥', 'Doctor'),
    _EmojiDef('🧪', 'Tests'),
    _EmojiDef('🩺', 'Checkup'),
    _EmojiDef('💉', 'Vaccine'),
    _EmojiDef('🧘', 'Wellness'),
    _EmojiDef('🏋️', 'Fitness'),
  ]),
  _EmojiGroup('Shopping', [
    _EmojiDef('👕', 'Clothes'),
    _EmojiDef('👟', 'Shoes'),
    _EmojiDef('🛍️', 'Shopping'),
    _EmojiDef('🎒', 'Bag'),
    _EmojiDef('💄', 'Beauty'),
    _EmojiDef('⌚', 'Accessories'),
  ]),
  _EmojiGroup('Education', [
    _EmojiDef('📚', 'Books'),
    _EmojiDef('🎓', 'Tuition'),
    _EmojiDef('✏️', 'Stationery'),
    _EmojiDef('💻', 'Online Course'),
    _EmojiDef('🏫', 'School'),
    _EmojiDef('📖', 'Education'),
  ]),
  _EmojiGroup('Entertainment', [
    _EmojiDef('🎬', 'Movies'),
    _EmojiDef('🎮', 'Games'),
    _EmojiDef('🎵', 'Music'),
    _EmojiDef('🎉', 'Events'),
    _EmojiDef('🍿', 'Streaming'),
    _EmojiDef('🎭', 'Entertainment'),
  ]),
  _EmojiGroup('Travel', [
    _EmojiDef('✈️', 'Flight'),
    _EmojiDef('🏨', 'Hotel'),
    _EmojiDef('🚗', 'Car'),
    _EmojiDef('🚂', 'Train'),
    _EmojiDef('🗺️', 'Trip'),
    _EmojiDef('🧳', 'Travel'),
  ]),
  _EmojiGroup('Social & Family', [
    _EmojiDef('👨‍👩‍👧‍👦', 'Family'),
    _EmojiDef('🎁', 'Gift'),
    _EmojiDef('❤️', 'Charity'),
    _EmojiDef('🕌', 'Zakat'),
    _EmojiDef('🤲', 'Sadaqah'),
    _EmojiDef('👶', 'Child'),
  ]),
  _EmojiGroup('Personal', [
    _EmojiDef('💇', 'Grooming'),
    _EmojiDef('🧴', 'Skincare'),
    _EmojiDef('👤', 'Personal'),
    _EmojiDef('🧹', 'Cleaning'),
    _EmojiDef('🛁', 'Self-care'),
    _EmojiDef('🪒', 'Hygiene'),
  ]),
  _EmojiGroup('Home & Maintenance', [
    _EmojiDef('🔨', 'Repair'),
    _EmojiDef('🪣', 'Plumbing'),
    _EmojiDef('🎨', 'Painting'),
    _EmojiDef('🪟', 'Furniture'),
    _EmojiDef('🏗️', 'Construction'),
    _EmojiDef('🔩', 'Maintenance'),
  ]),
  _EmojiGroup('Others', [
    _EmojiDef('📦', 'Package'),
    _EmojiDef('🗂️', 'Misc'),
    _EmojiDef('❓', 'Unknown'),
    _EmojiDef('📝', 'Note'),
    _EmojiDef('🔖', 'Tag'),
    _EmojiDef('⭐', 'Others'),
  ]),
];

// ── Tracker (member) quick-select ─────────────────────────────────────────────

class _TrackerDef {
  final String memberId;
  final String emoji;
  final String label;
  final Color color;
  const _TrackerDef(this.memberId, this.emoji, this.label, this.color);
}

const _kTrackers = [
  _TrackerDef('member_family',   '👨‍👩‍👧‍👦', 'Family',   Color(0xFF6C63FF)),
  _TrackerDef('member_personal', '👤',       'Personal', Color(0xFF3A86FF)),
  _TrackerDef('member_wife',     '👩',       'Wife',     Color(0xFFFF6584)),
  _TrackerDef('member_child',    '👦',       'Child',    Color(0xFFFFBE0B)),
];

// ── Screen ────────────────────────────────────────────────────────────────────

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
  late String _selectedEmoji;
  late bool _isUnnecessary;
  String _selectedTrackerId = 'member_family'; // default to Family

  bool get _isEditing => widget.category != null;

  // Flat list of all emojis for quick lookup
  static final _allEmojis = _kEmojiGroups
      .expand((g) => g.items)
      .toList();

  @override
  void initState() {
    super.initState();
    _selectedColor =
        widget.category?.color ?? AppColors.categoryPalette[0].toARGB32();
    // icon field stores emoji string; fall back to first emoji
    _selectedEmoji = widget.category?.icon ?? _allEmojis[0].emoji;
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<CategoryCubit>()),
        BlocProvider.value(value: sl<MemberCubit>()),
      ],
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
              // ── Preview ────────────────────────────────────────────────────
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(_selectedColor).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Color(_selectedColor).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _selectedEmoji,
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Name ───────────────────────────────────────────────────────
              const Text('Name', style: AppTextStyles.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration:
                    const InputDecoration(hintText: 'Category name'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: 24),

              // ── Color ──────────────────────────────────────────────────────
              const Text('Color', style: AppTextStyles.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: AppColors.categoryPalette.map((color) {
                  final isSelected = color.toARGB32() == _selectedColor;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedColor = color.toARGB32()),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface,
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
              const SizedBox(height: 28),

              // ── Emoji Picker ───────────────────────────────────────────────
              const Text('Icon', style: AppTextStyles.labelLarge),
              const SizedBox(height: 12),
              ..._kEmojiGroups.map((group) => _EmojiGroupSection(
                    group: group,
                    selectedEmoji: _selectedEmoji,
                    accentColor: Color(_selectedColor),
                    onSelect: (e) => setState(() => _selectedEmoji = e),
                  )),
              const SizedBox(height: 28),

              // ── Tracker ────────────────────────────────────────────────────
              const Text('Tracker', style: AppTextStyles.labelLarge),
              const SizedBox(height: 4),
              const Text(
                'Which spending profile does this category belong to?',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 12),
              _TrackerSelector(
                selectedId: _selectedTrackerId,
                onChanged: (id) => setState(() => _selectedTrackerId = id),
              ),
              const SizedBox(height: 28),

              // ── Unnecessary toggle ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
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
                              color:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const Text(
                            'Enables spending-leak alerts for this category',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isUnnecessary,
                      onChanged: (v) =>
                          setState(() => _isUnnecessary = v),
                      activeTrackColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Submit ─────────────────────────────────────────────────────
              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () => _submit(context),
                    child: Text(
                      _isEditing ? 'Update Category' : 'Create Category',
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
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
          icon: _selectedEmoji,
          isUnnecessary: _isUnnecessary,
        ),
      );
    } else {
      await cubit.createCategory(
        name: _nameController.text.trim(),
        color: _selectedColor,
        icon: _selectedEmoji,
        isUnnecessary: _isUnnecessary,
      );
    }

    if (context.mounted) context.pop();
  }
}

// ── Emoji group section ───────────────────────────────────────────────────────

class _EmojiGroupSection extends StatelessWidget {
  final _EmojiGroup group;
  final String selectedEmoji;
  final Color accentColor;
  final ValueChanged<String> onSelect;

  const _EmojiGroupSection({
    required this.group,
    required this.selectedEmoji,
    required this.accentColor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            group.title,
            style: AppTextStyles.labelMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: group.items.map((def) {
            final isSelected = def.emoji == selectedEmoji;
            return GestureDetector(
              onTap: () => onSelect(def.emoji),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isSelected
                      ? accentColor.withValues(alpha: 0.15)
                      : Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: isSelected
                      ? Border.all(color: accentColor, width: 1.5)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      def.emoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      def.label,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 9,
                        color: isSelected
                            ? accentColor
                            : Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Tracker selector ──────────────────────────────────────────────────────────

class _TrackerSelector extends StatelessWidget {
  final String selectedId;
  final ValueChanged<String> onChanged;

  const _TrackerSelector({
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _kTrackers.map((t) {
        final isSelected = t.memberId == selectedId;
        return GestureDetector(
          onTap: () => onChanged(t.memberId),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? t.color.withValues(alpha: 0.15)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? t.color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(
                  t.label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected
                        ? t.color
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
                if (t.memberId == 'member_family') ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: t.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'default',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: t.color,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
