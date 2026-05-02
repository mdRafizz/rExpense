// lib/presentation/analytics/analytics_screen.dart
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../widgets/category_icon_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../application/analytics/analytics_bloc.dart';
import '../../application/category/category_cubit.dart';
import '../../application/member/member_cubit.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/period_summary.dart';
import '../../domain/entities/spending_suggestion.dart';
import '../../domain/entities/variance_insight.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry point
// ─────────────────────────────────────────────────────────────────────────────

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return MultiBlocProvider(
      providers: [
        BlocProvider<AnalyticsBloc>(
          create: (_) => sl<AnalyticsBloc>()
            ..add(LoadMonthlyAnalytics(year: now.year, month: now.month)),
        ),
        BlocProvider<CategoryCubit>.value(value: sl<CategoryCubit>()),
        BlocProvider<MemberCubit>.value(value: sl<MemberCubit>()),
      ],
      child: const _AnalyticsView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main view with TabController + shared month state
// ─────────────────────────────────────────────────────────────────────────────

class _AnalyticsView extends StatefulWidget {
  const _AnalyticsView();

  @override
  State<_AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<_AnalyticsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    // Reload analytics for the current month when switching tabs
    context
        .read<AnalyticsBloc>()
        .add(LoadMonthlyAnalytics(year: _year, month: _month));
  }

  void _navigateMonth(int delta) {
    final dt = DateTime(_year, _month + delta);
    setState(() {
      _year = dt.year;
      _month = dt.month;
    });
    context
        .read<AnalyticsBloc>()
        .add(LoadMonthlyAnalytics(year: _year, month: _month));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Analytics',
          style: AppTextStyles.headlineMedium.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: AppTextStyles.labelLarge,
          unselectedLabelStyle: AppTextStyles.labelMedium,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Categories'),
            Tab(text: 'Members'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _OverviewTab(
            year: _year,
            month: _month,
            onNavigate: _navigateMonth,
          ),
          _CategoriesTab(
            year: _year,
            month: _month,
            onNavigate: _navigateMonth,
          ),
          _MembersTab(
            year: _year,
            month: _month,
            onNavigate: _navigateMonth,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared month navigation header
// ─────────────────────────────────────────────────────────────────────────────

class _MonthNavHeader extends StatelessWidget {
  final int year;
  final int month;
  final void Function(int delta) onNavigate;

  const _MonthNavHeader({
    required this.year,
    required this.month,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('MMMM yyyy').format(DateTime(year, month));
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final isCurrent = year == now.year && month == now.month;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => onNavigate(-1),
            icon: const Icon(Icons.chevron_left),
            color: colorScheme.onSurface,
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                label,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              if (isCurrent)
                Text(
                  'Current month',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: isCurrent ? null : () => onNavigate(1),
            icon: const Icon(Icons.chevron_right),
            color: isCurrent
                ? colorScheme.onSurface.withValues(alpha: 0.3)
                : colorScheme.onSurface,
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerHighest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1: Overview
// ─────────────────────────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final int year;
  final int month;
  final void Function(int delta) onNavigate;

  const _OverviewTab({
    required this.year,
    required this.month,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return switch (state) {
          AnalyticsInitial() || AnalyticsLoading() => const _LoadingView(),
          AnalyticsError(:final message) => _ErrorView(message: message),
          MonthlyAnalyticsLoaded() => _OverviewContent(
              state: state,
              year: year,
              month: month,
              onNavigate: onNavigate,
            ),
          YearlyAnalyticsLoaded() => const _LoadingView(),
        };
      },
    );
  }
}

class _OverviewContent extends StatelessWidget {
  final MonthlyAnalyticsLoaded state;
  final int year;
  final int month;
  final void Function(int delta) onNavigate;

  const _OverviewContent({
    required this.state,
    required this.year,
    required this.month,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final summary = state.currentSummary;
    final net = summary.netBalance;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MonthNavHeader(year: year, month: month, onNavigate: onNavigate),

          // ── Summary cards ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Income',
                    amount: summary.totalIncome,
                    color: AppColors.income,
                    icon: Icons.arrow_downward_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    label: 'Expenses',
                    amount: summary.totalExpense,
                    color: AppColors.expense,
                    icon: Icons.arrow_upward_rounded,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Net balance ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (net >= 0 ? AppColors.income : AppColors.expense)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (net >= 0 ? AppColors.income : AppColors.expense)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    net >= 0
                        ? Icons.savings_outlined
                        : Icons.warning_amber_rounded,
                    color: net >= 0 ? AppColors.income : AppColors.expense,
                    size: 28,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Net Balance',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.full(net.abs()),
                          style: AppTextStyles.amountLarge.copyWith(
                            color:
                                net >= 0 ? AppColors.income : AppColors.expense,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (summary.totalIncome > 0)
                    _SavingsRateBadge(rate: summary.savingsRate),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── 6-Month Trend ──────────────────────────────────────────────────
          if (state.chartData.isNotEmpty) ...[
            _SectionHeader(title: '6-Month Trend'),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _TrendBarChart(chartData: state.chartData),
            ),
            const SizedBox(height: 24),
          ],

          // ── Spending Leaks ─────────────────────────────────────────────────
          if (state.suggestions.isNotEmpty) ...[
            _SectionHeader(title: 'Spending Leaks'),
            const SizedBox(height: 8),
            ...state.suggestions.map(
              (s) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: _SuggestionCard(suggestion: s),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // ── Period Insights ────────────────────────────────────────────────
          if (state.variances.isNotEmpty) ...[
            _SectionHeader(title: 'Period Insights'),
            const SizedBox(height: 8),
            ...state.variances.map(
              (v) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: _VarianceCard(variance: v),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2: Categories
// ─────────────────────────────────────────────────────────────────────────────

class _CategoriesTab extends StatelessWidget {
  final int year;
  final int month;
  final void Function(int delta) onNavigate;

  const _CategoriesTab({
    required this.year,
    required this.month,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return switch (state) {
          AnalyticsInitial() || AnalyticsLoading() => const _LoadingView(),
          AnalyticsError(:final message) => _ErrorView(message: message),
          MonthlyAnalyticsLoaded() => BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, catState) {
                final categories = catState is CategoryLoaded
                    ? catState.categories
                    : <Category>[];
                return _CategoriesContent(
                  state: state,
                  categories: categories,
                  year: year,
                  month: month,
                  onNavigate: onNavigate,
                );
              },
            ),
          YearlyAnalyticsLoaded() => const _LoadingView(),
        };
      },
    );
  }
}

class _CategoriesContent extends StatelessWidget {
  final MonthlyAnalyticsLoaded state;
  final List<Category> categories;
  final int year;
  final int month;
  final void Function(int delta) onNavigate;

  const _CategoriesContent({
    required this.state,
    required this.categories,
    required this.year,
    required this.month,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final expenseMap = state.currentSummary.expenseByCategory;
    final total = state.currentSummary.totalExpense;

    // Build sorted list of (category, amount)
    final entries = expenseMap.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (entries.isEmpty) {
      return Column(
        children: [
          _MonthNavHeader(year: year, month: month, onNavigate: onNavigate),
          const Expanded(
            child: _EmptyState(
              icon: Icons.pie_chart_outline,
              message: 'No category expenses this month',
            ),
          ),
        ],
      );
    }

    // Map categoryId -> Category entity
    final catById = {for (final c in categories) c.id: c};

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MonthNavHeader(year: year, month: month, onNavigate: onNavigate),

          // ── Pie chart ──────────────────────────────────────────────────────
          _SectionHeader(title: 'Top Spending'),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _CategoryPieChart(
              entries: entries,
              catById: catById,
              total: total,
            ),
          ),
          const SizedBox(height: 24),

          // ── Category breakdown ─────────────────────────────────────────────
          _SectionHeader(title: 'Category Breakdown'),
          const SizedBox(height: 8),
          ...entries.indexed.map((record) {
            final i = record.$1;
            final e = record.$2;
            final cat = catById[e.key];
            final pct = total > 0 ? e.value / total : 0.0;
            final color = cat != null
                ? Color(cat.color)
                : AppColors.categoryPalette[
                    i % AppColors.categoryPalette.length];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: _CategoryProgressRow(
                icon: cat?.icon ?? '',
                name: cat?.name ?? e.key,
                amount: e.value,
                percent: pct,
                color: color,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 3: Members
// ─────────────────────────────────────────────────────────────────────────────

class _MembersTab extends StatelessWidget {
  final int year;
  final int month;
  final void Function(int delta) onNavigate;

  const _MembersTab({
    required this.year,
    required this.month,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return switch (state) {
          AnalyticsInitial() || AnalyticsLoading() => const _LoadingView(),
          AnalyticsError(:final message) => _ErrorView(message: message),
          MonthlyAnalyticsLoaded() =>
            BlocBuilder<MemberCubit, MemberState>(
              builder: (context, memberState) {
                final members = memberState is MemberLoaded
                    ? memberState.members
                    : <Member>[];
                return BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, catState) {
                    final categories = catState is CategoryLoaded
                        ? catState.categories
                        : <Category>[];
                    return _MembersContent(
                      state: state,
                      members: members,
                      categories: categories,
                      year: year,
                      month: month,
                      onNavigate: onNavigate,
                    );
                  },
                );
              },
            ),
          YearlyAnalyticsLoaded() => const _LoadingView(),
        };
      },
    );
  }
}

class _MembersContent extends StatelessWidget {
  final MonthlyAnalyticsLoaded state;
  final List<Member> members;
  final List<Category> categories;
  final int year;
  final int month;
  final void Function(int delta) onNavigate;

  const _MembersContent({
    required this.state,
    required this.members,
    required this.categories,
    required this.year,
    required this.month,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final expenseByMember = state.expenseByMember;
    final catPerMember = state.expenseByCategoryPerMember;
    final catById = {for (final c in categories) c.id: c};

    // Only show members that have expenses
    final activeMembers = members
        .where((m) => (expenseByMember[m.id] ?? 0) > 0)
        .toList()
      ..sort((a, b) =>
          (expenseByMember[b.id] ?? 0).compareTo(expenseByMember[a.id] ?? 0));

    if (activeMembers.isEmpty) {
      return Column(
        children: [
          _MonthNavHeader(year: year, month: month, onNavigate: onNavigate),
          const Expanded(
            child: _EmptyState(
              icon: Icons.people_outline,
              message: 'No member expenses this month',
            ),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MonthNavHeader(year: year, month: month, onNavigate: onNavigate),
          _SectionHeader(title: 'Member Breakdown'),
          const SizedBox(height: 8),
          ...activeMembers.map((member) {
            final total = expenseByMember[member.id] ?? 0;
            final catMap = catPerMember[member.id] ?? {};
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _MemberExpenseCard(
                member: member,
                totalExpense: total,
                categoryExpenses: catMap,
                catById: catById,
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chart widgets
// ─────────────────────────────────────────────────────────────────────────────

class _TrendBarChart extends StatelessWidget {
  final Map<DateTime, PeriodSummary> chartData;

  const _TrendBarChart({required this.chartData});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sortedKeys = chartData.keys.toList()..sort();

    final groups = <BarChartGroupData>[];
    for (var i = 0; i < sortedKeys.length; i++) {
      final key = sortedKeys[i];
      final summary = chartData[key]!;
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: summary.totalIncome,
              color: AppColors.income,
              width: 8,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            BarChartRodData(
              toY: summary.totalExpense,
              color: AppColors.expense,
              width: 8,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
          barsSpace: 3,
        ),
      );
    }

    final maxY = chartData.values.fold<double>(0, (prev, s) {
      return math.max(prev, math.max(s.totalIncome, s.totalExpense));
    });

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LegendDot(color: AppColors.income, label: 'Income'),
              const SizedBox(width: 16),
              _LegendDot(color: AppColors.expense, label: 'Expense'),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: maxY * 1.2,
                barGroups: groups,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY > 0 ? maxY / 4 : 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colorScheme.outlineVariant,
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= sortedKeys.length) {
                          return const SizedBox.shrink();
                        }
                        final label =
                            DateFormat('MMM').format(sortedKeys[idx]);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            label,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => colorScheme.inverseSurface,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label =
                          rodIndex == 0 ? 'Income' : 'Expense';
                      return BarTooltipItem(
                        '$label\n${CurrencyFormatter.compact(rod.toY)}',
                        AppTextStyles.labelSmall.copyWith(
                          color: colorScheme.onInverseSurface,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPieChart extends StatefulWidget {
  final List<MapEntry<String, double>> entries;
  final Map<String, Category> catById;
  final double total;

  const _CategoryPieChart({
    required this.entries,
    required this.catById,
    required this.total,
  });

  @override
  State<_CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<_CategoryPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final sections = <PieChartSectionData>[];
    for (var i = 0; i < widget.entries.length; i++) {
      final e = widget.entries[i];
      final cat = widget.catById[e.key];
      final color = cat != null
          ? Color(cat.color)
          : AppColors.categoryPalette[i % AppColors.categoryPalette.length];
      final isTouched = i == _touchedIndex;
      final pct = widget.total > 0 ? (e.value / widget.total * 100) : 0.0;

      sections.add(
        PieChartSectionData(
          value: e.value,
          color: color,
          radius: isTouched ? 72 : 60,
          title: isTouched ? '${pct.toStringAsFixed(1)}%' : '',
          titleStyle: AppTextStyles.labelSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          badgeWidget: null,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: sections,
                    centerSpaceRadius: 52,
                    sectionsSpace: 2,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.touchedSection == null) {
                            _touchedIndex = -1;
                            return;
                          }
                          _touchedIndex = response
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.compact(widget.total),
                      style: AppTextStyles.amountMedium.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: List.generate(widget.entries.length, (i) {
              final e = widget.entries[i];
              final cat = widget.catById[e.key];
              final color = cat != null
                  ? Color(cat.color)
                  : AppColors.categoryPalette[
                      i % AppColors.categoryPalette.length];
              final pct = widget.total > 0
                  ? (e.value / widget.total * 100)
                  : 0.0;
              return GestureDetector(
                onTap: () => setState(() {
                  _touchedIndex = _touchedIndex == i ? -1 : i;
                }),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (cat != null)
                      _categoryIconWidget(cat.icon, color, 14),
                    const SizedBox(width: 2),
                    Text(
                      cat?.name ?? e.key,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${pct.toStringAsFixed(1)}%',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Member expense card
// ─────────────────────────────────────────────────────────────────────────────

class _MemberExpenseCard extends StatefulWidget {
  final Member member;
  final double totalExpense;
  final Map<String, double> categoryExpenses;
  final Map<String, Category> catById;

  const _MemberExpenseCard({
    required this.member,
    required this.totalExpense,
    required this.categoryExpenses,
    required this.catById,
  });

  @override
  State<_MemberExpenseCard> createState() => _MemberExpenseCardState();
}

class _MemberExpenseCardState extends State<_MemberExpenseCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final memberColor = Color(widget.member.color);

    // Sort categories by amount descending
    final sortedCats = widget.categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final previewCats = sortedCats.take(3).toList();
    final allCats = sortedCats;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: memberColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.member.emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.member.name,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${sortedCats.length} categories',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    CurrencyFormatter.full(widget.totalExpense),
                    style: AppTextStyles.amountMedium.copyWith(
                      color: AppColors.expense,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Preview bars (always visible — top 3)
          if (previewCats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: previewCats.map((e) {
                  final cat = widget.catById[e.key];
                  final color = cat != null
                      ? Color(cat.color)
                      : memberColor;
                  final pct = widget.totalExpense > 0
                      ? e.value / widget.totalExpense
                      : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _CategoryProgressRow(
                      icon: cat?.icon ?? '',
                      name: cat?.name ?? e.key,
                      amount: e.value,
                      percent: pct,
                      color: color,
                      compact: true,
                    ),
                  );
                }).toList(),
              ),
            ),

          // Expanded: remaining categories
          if (_expanded && allCats.length > 3)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: allCats.skip(3).map((e) {
                  final cat = widget.catById[e.key];
                  final color = cat != null
                      ? Color(cat.color)
                      : memberColor;
                  final pct = widget.totalExpense > 0
                      ? e.value / widget.totalExpense
                      : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _CategoryProgressRow(
                      icon: cat?.icon ?? '',
                      name: cat?.name ?? e.key,
                      amount: e.value,
                      percent: pct,
                      color: color,
                      compact: true,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            CurrencyFormatter.full(amount),
            style: AppTextStyles.amountMedium.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SavingsRateBadge extends StatelessWidget {
  final double rate;

  const _SavingsRateBadge({required this.rate});

  @override
  Widget build(BuildContext context) {
    final isPositive = rate >= 0;
    final color = isPositive ? AppColors.income : AppColors.expense;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${rate.toStringAsFixed(1)}%\nsaved',
        textAlign: TextAlign.center,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
    );
  }
}

class _CategoryProgressRow extends StatelessWidget {
  final String icon;
  final String name;
  final double amount;
  final double percent;
  final Color color;
  final bool compact;

  const _CategoryProgressRow({
    required this.icon,
    required this.name,
    required this.amount,
    required this.percent,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(compact ? 10 : 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: compact
            ? null
            : Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          _categoryIconWidget(icon, color, compact ? 18 : 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: (compact
                                ? AppTextStyles.bodySmall
                                : AppTextStyles.labelLarge)
                            .copyWith(color: colorScheme.onSurface),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      CurrencyFormatter.compact(amount),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent.clamp(0.0, 1.0),
                    backgroundColor:
                        colorScheme.outlineVariant.withValues(alpha: 0.5),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: compact ? 4 : 6,
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${(percent * 100).toStringAsFixed(1)}% of total',
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final SpendingSuggestion suggestion;

  const _SuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = switch (suggestion.severity) {
      SuggestionSeverity.high => AppColors.danger,
      SuggestionSeverity.medium => AppColors.warning,
      SuggestionSeverity.low => AppColors.primary,
    };
    final icon = switch (suggestion.severity) {
      SuggestionSeverity.high => Icons.warning_rounded,
      SuggestionSeverity.medium => Icons.lightbulb_outline,
      SuggestionSeverity.low => Icons.info_outline,
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.categoryName,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  suggestion.message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Spent: ${CurrencyFormatter.full(suggestion.spent)}',
                      style: AppTextStyles.labelSmall.copyWith(color: color),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Limit: ${CurrencyFormatter.full(suggestion.threshold)}',
                      style: AppTextStyles.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VarianceCard extends StatelessWidget {
  final VarianceInsight variance;

  const _VarianceCard({required this.variance});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUp = variance.direction == VarianceDirection.up;
    final isNeutral = variance.direction == VarianceDirection.neutral;
    final color = isNeutral
        ? colorScheme.onSurfaceVariant
        : isUp
            ? AppColors.expense
            : AppColors.income;
    final icon = isNeutral
        ? Icons.remove
        : isUp
            ? Icons.trending_up
            : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  variance.categoryName,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  variance.message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.percent(variance.variancePercent),
            style: AppTextStyles.labelLarge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: AppTextStyles.headlineSmall.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 2.5,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.danger,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppTextStyles.headlineSmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 56,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper: render a category icon (emoji string or hex codepoint)
// ─────────────────────────────────────────────────────────────────────────────

/// Renders a category icon. The [icon] field is either:
/// - A multi-character emoji string (e.g. "🍔")
/// - A hex codepoint string for a Material icon (e.g. "e318")
Widget _categoryIconWidget(String icon, Color color, double size) =>
    buildCategoryIcon(icon, color: color, size: size);
