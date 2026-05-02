import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../application/transaction/transaction_cubit.dart';
import '../../application/category/category_cubit.dart';
import '../../application/member/member_cubit.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/member.dart';
import '../widgets/category_chip.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType? initialType;
  final Transaction? existingTransaction;

  /// Pre-selected category id (used by quick-track buttons).
  final String? initialCategoryId;

  const AddTransactionScreen({
    super.key,
    this.initialType,
    this.existingTransaction,
    this.initialCategoryId,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late TransactionType _type;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategoryId;
  String? _selectedMemberId;
  late DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.existingTransaction != null;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType ??
        widget.existingTransaction?.type ??
        TransactionType.expense;
    _selectedDate = widget.existingTransaction?.date ?? DateTime.now();
    _selectedCategoryId =
        widget.initialCategoryId ?? widget.existingTransaction?.categoryId;

    if (_isEditing) {
      _amountController.text =
          widget.existingTransaction!.amount.toStringAsFixed(2);
      _noteController.text = widget.existingTransaction!.note ?? '';
      _selectedMemberId = widget.existingTransaction!.memberId;
    } else {
      // For expenses default to the active member (Family).
      // Income has no member — it's category-only.
      _selectedMemberId = sl<MemberCubit>().effectiveMemberId;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TransactionCubit>()),
        BlocProvider.value(value: sl<CategoryCubit>()),
        BlocProvider.value(value: sl<MemberCubit>()),
      ],
      child: BlocListener<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionSuccess) context.pop();
          if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        child: _buildScaffold(context),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Transaction' : 'New Transaction'),
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
            // ── Type Toggle ────────────────────────────────────────────────
            _TypeToggle(
              selected: _type,
              onChanged: (t) => setState(() {
                _type = t;
                // Income is member-independent; reset member for income
                if (t == TransactionType.income) {
                  _selectedMemberId = null;
                } else {
                  // Restore default member for expense
                  _selectedMemberId ??= sl<MemberCubit>().effectiveMemberId;
                }
              }),
            ),
            const SizedBox(height: 24),

            // ── Member Selector (expense only) ─────────────────────────────
            if (_type == TransactionType.expense) ...[
              const Text('For', style: AppTextStyles.labelLarge),
              const SizedBox(height: 10),
              BlocBuilder<MemberCubit, MemberState>(
                builder: (context, state) {
                  if (state is! MemberLoaded) return const SizedBox.shrink();
                  return _MemberSelector(
                    members: state.members,
                    selectedId: _selectedMemberId,
                    onChanged: (id) => setState(() => _selectedMemberId = id),
                  );
                },
              ),
              if (_selectedMemberId == null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'Select a member for this expense',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.danger),
                  ),
                ),
              const SizedBox(height: 24),
            ],

            // ── Amount ─────────────────────────────────────────────────────
            Text('Amount', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              autofocus: widget.initialCategoryId != null,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: AppTextStyles.amountLarge.copyWith(
                color: _type == TransactionType.income
                    ? AppColors.income
                    : AppColors.expense,
              ),
              decoration: InputDecoration(
                prefixText: '৳ ',
                prefixStyle: AppTextStyles.amountLarge.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.4),
                ),
                hintText: '0.00',
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter an amount';
                if (double.tryParse(v) == null) return 'Invalid amount';
                if (double.parse(v) <= 0) return 'Amount must be positive';
                return null;
              },
            ),
            const SizedBox(height: 24),

            // ── Category ───────────────────────────────────────────────────
            Text('Category', style: AppTextStyles.labelLarge),
            const SizedBox(height: 12),
            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                if (state is! CategoryLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.categories
                      .map(
                        (cat) => CategoryChip(
                          category: cat,
                          selected: _selectedCategoryId == cat.id,
                          onTap: () =>
                              setState(() => _selectedCategoryId = cat.id),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            if (_selectedCategoryId == null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Please select a category',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.danger),
                ),
              ),
            const SizedBox(height: 24),

            // ── Date ───────────────────────────────────────────────────────
            Text('Date', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('MMMM d, y').format(_selectedDate),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Note ───────────────────────────────────────────────────────
            Text('Note (optional)', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Add a note...'),
            ),
            const SizedBox(height: 32),

            // ── Submit ─────────────────────────────────────────────────────
            BlocBuilder<TransactionCubit, TransactionState>(
              builder: (context, state) {
                final isLoading = state is TransactionLoading;
                return ElevatedButton(
                  onPressed: isLoading ? null : () => _submit(context),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(_isEditing ? 'Update' : 'Save Transaction'),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      setState(() {});
      return;
    }
    // Member is required for expenses
    if (_type == TransactionType.expense && _selectedMemberId == null) {
      setState(() {});
      return;
    }

    final amount = double.parse(_amountController.text);
    final cubit = context.read<TransactionCubit>();

    if (_isEditing) {
      cubit.updateTransaction(
        widget.existingTransaction!.copyWith(
          amount: amount,
          type: _type,
          categoryId: _selectedCategoryId,
          memberId: _type == TransactionType.expense ? _selectedMemberId : null,
          note: _noteController.text.isEmpty ? null : _noteController.text,
          date: _selectedDate,
        ),
      );
    } else {
      cubit.addTransaction(
        amount: amount,
        type: _type,
        categoryId: _selectedCategoryId!,
        memberId: _type == TransactionType.expense ? _selectedMemberId : null,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        date: _selectedDate,
      );
    }
  }
}

// ── Member Selector ───────────────────────────────────────────────────────────

class _MemberSelector extends StatelessWidget {
  final List<Member> members;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const _MemberSelector({
    required this.members,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: members.map((member) {
          final isSelected = member.id == selectedId;
          final color = Color(member.color);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(member.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.15)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? color : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(member.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      member.name,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected
                            ? color
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Type Toggle ───────────────────────────────────────────────────────────────

class _TypeToggle extends StatelessWidget {
  final TransactionType selected;
  final ValueChanged<TransactionType> onChanged;

  const _TypeToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _ToggleOption(
            label: 'Expense',
            icon: Icons.arrow_upward_rounded,
            color: AppColors.expense,
            isSelected: selected == TransactionType.expense,
            onTap: () => onChanged(TransactionType.expense),
          ),
          _ToggleOption(
            label: 'Income',
            icon: Icons.arrow_downward_rounded,
            color: AppColors.income,
            isSelected: selected == TransactionType.income,
            onTap: () => onChanged(TransactionType.income),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  color: isSelected
                      ? color
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
