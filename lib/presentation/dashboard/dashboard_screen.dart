import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../application/dashboard/dashboard_cubit.dart';
import '../../application/category/category_cubit.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/transaction.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_list_item.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<DashboardCubit>()),
        BlocProvider.value(value: sl<CategoryCubit>()),
      ],
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return switch (state) {
              DashboardLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              DashboardError(:final message) => Center(
                  child: Text(message),
                ),
              DashboardLoaded() => _LoadedBody(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  final DashboardLoaded state;

  const _LoadedBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DashboardCubit>();
    final categories = context.watch<CategoryCubit>().state;
    final categoryMap = categories is CategoryLoaded
        ? {for (final c in categories.categories) c.id: c}
        : <String, dynamic>{};

    return CustomScrollView(
      slivers: [
        // ── App Bar ──────────────────────────────────────────────────────────
        SliverAppBar(
          floating: true,
          snap: true,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rexpense',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    DateFormat('MMMM y').format(state.selectedMonth),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            // Month navigation
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: cubit.previousMonth,
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: cubit.nextMonth,
            ),
            const SizedBox(width: 8),
          ],
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Summary Card ───────────────────────────────────────────────
              SummaryCard(
                income: state.summary.totalIncome,
                expense: state.summary.totalExpense,
                periodLabel: DateFormat('MMMM y').format(state.selectedMonth),
              ),
              const SizedBox(height: 28),

              // ── Quick Actions ──────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      label: 'Add Income',
                      icon: Icons.add_circle_outline,
                      color: AppColors.income,
                      onTap: () => context.push(
                        '/transactions/add',
                        extra: {'type': TransactionType.income},
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionButton(
                      label: 'Add Expense',
                      icon: Icons.remove_circle_outline,
                      color: AppColors.expense,
                      onTap: () => context.push(
                        '/transactions/add',
                        extra: {'type': TransactionType.expense},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Transactions Header ────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '${state.transactions.length} total',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ]),
          ),
        ),

        // ── Transaction List ─────────────────────────────────────────────────
        if (state.transactions.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: SliverList.separated(
              itemCount: state.transactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final t = state.transactions[index];
                final category = categoryMap[t.categoryId];
                return TransactionListItem(
                  transaction: t,
                  category: category,
                  onTap: () => context.push(
                    '/transactions/detail',
                    extra: t,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
