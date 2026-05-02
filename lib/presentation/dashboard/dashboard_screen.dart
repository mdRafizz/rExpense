import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../application/dashboard/dashboard_cubit.dart';
import '../../application/category/category_cubit.dart';
import '../../application/member/member_cubit.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/member.dart';
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
        BlocProvider.value(value: sl<MemberCubit>()),
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
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) => switch (state) {
          DashboardLoading() =>
            const Center(child: CircularProgressIndicator()),
          DashboardError(:final message) => Center(child: Text(message)),
          DashboardLoaded() => _LoadedBody(state: state),
        },
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
    final catState = context.watch<CategoryCubit>().state;
    final categoryMap = catState is CategoryLoaded
        ? {for (final c in catState.categories) c.id: c}
        : <String, dynamic>{};
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;

    return Column(
      children: [
        // ── Sticky Header (AppBar + SummaryCard) ─────────────────────────────
        _GlassHeader(
          state: state,
          cubit: cubit,
          isDark: isDark,
          topPadding: topPadding,
        ),

        // ── Scrollable Transaction List ───────────────────────────────────────
        Expanded(
          child: state.transactions.isEmpty
              ? _EmptyTransactions()
              : _TransactionList(
                  transactions: state.transactions,
                  categoryMap: categoryMap,
                ),
        ),
      ],
    );
  }
}

// ── Glass Header ──────────────────────────────────────────────────────────────

class _GlassHeader extends StatelessWidget {
  final DashboardLoaded state;
  final DashboardCubit cubit;
  final bool isDark;
  final double topPadding;

  const _GlassHeader({
    required this.state,
    required this.cubit,
    required this.isDark,
    required this.topPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.white.withValues(alpha: 0.72),
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.6),
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topPadding + 8),

              // ── Title row ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'rExpense',
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
                    ),
                    _GlassIconButton(
                      icon: Icons.chevron_left,
                      onTap: cubit.previousMonth,
                    ),
                    const SizedBox(width: 8),
                    _GlassIconButton(
                      icon: Icons.chevron_right,
                      onTap: cubit.nextMonth,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Summary Card ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SummaryCard(
                  income: state.summary.totalIncome,
                  expense: state.summary.totalExpense,
                  periodLabel: DateFormat('MMMM y').format(state.selectedMonth),
                ),
              ),
              const SizedBox(height: 16),

              // ── Transactions header ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    _GlassBadge(
                      label: '${state.transactions.length} total',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Glass Icon Button ─────────────────────────────────────────────────────────

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.8),
                width: 0.5,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Glass Badge ───────────────────────────────────────────────────────────────

class _GlassBadge extends StatelessWidget {
  final String label;
  final bool isDark;

  const _GlassBadge({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.7),
              width: 0.5,
            ),
          ),
          child: Text(label, style: AppTextStyles.labelSmall),
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first transaction',
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Transaction List ──────────────────────────────────────────────────────────

class _TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Map<String, dynamic> categoryMap;

  const _TransactionList({
    required this.transactions,
    required this.categoryMap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      itemCount: transactions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final t = transactions[index];
        return TransactionListItem(
          transaction: t,
          category: categoryMap[t.categoryId],
          onTap: () async {
            await context.push('/transactions/detail', extra: t);
          },
        );
      },
    );
  }
}

// ── Member Strip (kept for future use) ───────────────────────────────────────
// ignore: unused_element
class _MemberStrip extends StatelessWidget {
  final List<Member> members;
  final String? activeMemberId;
  final ValueChanged<String?> onSelect;

  const _MemberStrip({
    required this.members,
    required this.activeMemberId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: members.map((m) {
          final isActive = m.id == activeMemberId;
          final color = Color(m.color);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(m.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? color.withValues(alpha: 0.15)
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? color : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(m.emoji, style: const TextStyle(fontSize: 15)),
                    const SizedBox(width: 6),
                    Text(
                      m.name,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isActive
                            ? color
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w500,
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
