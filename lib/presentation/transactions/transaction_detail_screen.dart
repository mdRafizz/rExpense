import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../application/transaction/transaction_cubit.dart';
import '../../application/category/category_cubit.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<TransactionCubit>()),
        BlocProvider.value(value: sl<CategoryCubit>()),
      ],
      child: BlocListener<TransactionCubit, TransactionState>(
        listener: (context, state) {
          if (state is TransactionDeleted) context.pop();
        },
        child: _DetailView(transaction: transaction),
      ),
    );
  }
}

class _DetailView extends StatelessWidget {
  final Transaction transaction;

  const _DetailView({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final color = isIncome ? AppColors.income : AppColors.expense;

    final categoryState = context.watch<CategoryCubit>().state;
    final category = categoryState is CategoryLoaded
        ? categoryState.categories
            .where((c) => c.id == transaction.categoryId)
            .firstOrNull
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(
              '/transactions/edit',
              extra: transaction,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // Amount hero
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isIncome
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: color,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${isIncome ? '+' : '-'}${CurrencyFormatter.full(transaction.amount)}',
              style: AppTextStyles.amountHero.copyWith(color: color),
            ),
            const SizedBox(height: 8),
            Text(
              isIncome ? 'Income' : 'Expense',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),

            // Details card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    label: 'Category',
                    value: category?.name ?? 'Unknown',
                    icon: category != null
                        ? IconData(
                            int.parse(category.icon, radix: 16),
                            fontFamily: 'MaterialIcons',
                          )
                        : Icons.category_outlined,
                    iconColor:
                        category != null ? Color(category.color) : null,
                  ),
                  const Divider(height: 24),
                  _DetailRow(
                    label: 'Date',
                    value: DateFormat('EEEE, MMMM d, y')
                        .format(transaction.date),
                    icon: Icons.calendar_today_outlined,
                  ),
                  if (transaction.note != null &&
                      transaction.note!.isNotEmpty) ...[
                    const Divider(height: 24),
                    _DetailRow(
                      label: 'Note',
                      value: transaction.note!,
                      icon: Icons.notes_outlined,
                    ),
                  ],
                  const Divider(height: 24),
                  _DetailRow(
                    label: 'Added',
                    value: DateFormat('MMM d, y · h:mm a')
                        .format(transaction.createdAt),
                    icon: Icons.access_time_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<TransactionCubit>().deleteTransaction(transaction.id);
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelSmall),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
