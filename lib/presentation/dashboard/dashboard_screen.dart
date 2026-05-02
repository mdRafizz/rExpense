import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../application/dashboard/dashboard_cubit.dart';
import '../../application/category/category_cubit.dart';
import '../../application/member/member_cubit.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/member.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_list_item.dart';

// ── Quick-track category ids & display config ─────────────────────────────────
// These map to the seeded category ids in app_database.dart
const _quickTrackItems = [
  _QuickTrackDef(
    categoryId: 'cat_egg',
    label: 'Egg',
    emoji: '🥚',
    color: Color(0xFFFFBE0B),
  ),
  _QuickTrackDef(
    categoryId: 'cat_electricity',
    label: 'Electric',
    emoji: '⚡',
    color: Color(0xFFFFBE0B),
  ),
  _QuickTrackDef(
    categoryId: 'cat_medicine',
    label: 'Medicine',
    emoji: '💊',
    color: Color(0xFFEF476F),
  ),
  _QuickTrackDef(
    categoryId: 'cat_transport',
    label: 'Transport',
    emoji: '🚌',
    color: Color(0xFF3A86FF),
  ),
];

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
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) => switch (state) {
            DashboardLoading() =>
              const Center(child: CircularProgressIndicator()),
            DashboardError(:final message) => Center(child: Text(message)),
            DashboardLoaded() => _LoadedBody(state: state),
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
    final catState = context.watch<CategoryCubit>().state;
    final categoryMap = catState is CategoryLoaded
        ? {for (final c in catState.categories) c.id: c}
        : <String, dynamic>{};

    return CustomScrollView(
      slivers: [
        // ── App Bar ──────────────────────────────────────────────────────────
        SliverAppBar(
          floating: true,
          snap: true,
          titleSpacing: 20,
          title: Column(
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
          actions: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: cubit.previousMonth,
              tooltip: 'Previous month',
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: cubit.nextMonth,
              tooltip: 'Next month',
            ),
            const SizedBox(width: 8),
          ],
        ),

        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Member Strip ───────────────────────────────────────────────
              /*BlocBuilder<MemberCubit, MemberState>(
                builder: (context, memberState) {
                  if (memberState is! MemberLoaded) return const SizedBox.shrink();
                  return _MemberStrip(
                    members: memberState.members,
                    activeMemberId: memberState.activeMemberId,
                    onSelect: (id) =>
                        context.read<MemberCubit>().selectMember(id),
                  );
                },
              ),
              const SizedBox(height: 20),
*/
              // ── Summary Card ───────────────────────────────────────────────
              SummaryCard(
                income: state.summary.totalIncome,
                expense: state.summary.totalExpense,
                periodLabel: DateFormat('MMMM y').format(state.selectedMonth),
              ),
              const SizedBox(height: 24),

              // ── Quick Track ────────────────────────────────────────────────
              /*const Text('Quick Track', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 12),
              _QuickTrackRow(
                items: _quickTrackItems,
                defaultMemberId: sl<MemberCubit>().effectiveMemberId,
              ),
              const SizedBox(height: 24),*/

              // ── Add buttons ────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
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
                    child: _ActionButton(
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

              // ── Transactions header ────────────────────────────────────────
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
                return TransactionListItem(
                  transaction: t,
                  category: categoryMap[t.categoryId],
                  onTap: () =>
                      context.push('/transactions/detail', extra: t),
                );
              },
            ),
          ),
      ],
    );
  }
}

// ── Member Strip ──────────────────────────────────────────────────────────────

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

// ── Quick Track Row ───────────────────────────────────────────────────────────

class _QuickTrackRow extends StatelessWidget {
  final List<_QuickTrackDef> items;
  final String? defaultMemberId;

  const _QuickTrackRow({required this.items, this.defaultMemberId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _QuickTrackButton(
              def: item,
              defaultMemberId: defaultMemberId,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _QuickTrackButton extends StatelessWidget {
  final _QuickTrackDef def;
  final String? defaultMemberId;

  const _QuickTrackButton({
    required this.def,
    this.defaultMemberId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        '/transactions/add',
        extra: {
          'type': TransactionType.expense,
          'categoryId': def.categoryId,
          'memberId': defaultMemberId,
        },
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: def.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: def.color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(def.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              def.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: def.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTrackDef {
  final String categoryId;
  final String label;
  final String emoji;
  final Color color;

  const _QuickTrackDef({
    required this.categoryId,
    required this.label,
    required this.emoji,
    required this.color,
  });
}

// ── Action Button ─────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
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
          border: Border.all(color: color.withValues(alpha: 0.2)),
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
