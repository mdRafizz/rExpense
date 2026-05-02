import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../application/analytics/analytics_bloc.dart';
import '../../core/di/injection.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/period_summary.dart';
import '../../domain/entities/variance_insight.dart';
import '../../domain/entities/spending_suggestion.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AnalyticsBloc>()
        ..add(LoadMonthlyAnalytics(year: _now.year, month: _now.month)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
          bottom: TabBar(
            controller: _tabController,
            onTap: (index) {
              final bloc = context.read<AnalyticsBloc>();
              if (index == 0) {
                bloc.add(LoadMonthlyAnalytics(
                  year: _now.year,
                  month: _now.month,
                ));
              } else {
                bloc.add(LoadYearlyAnalytics(year: _now.year));
              }
            },
            tabs: const [
              Tab(text: 'Monthly'),
              Tab(text: 'Yearly'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            _MonthlyView(),
            _YearlyView(),
          ],
        ),
      ),
    );
  }
}

// ── Monthly View ─────────────────────────────────────────────────────────────

class _MonthlyView extends StatelessWidget {
  const _MonthlyView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return switch (state) {
          AnalyticsLoading() || AnalyticsInitial() =>
            const Center(child: CircularProgressIndicator()),
          AnalyticsError(:final message) => Center(child: Text(message)),
          MonthlyAnalyticsLoaded() =>
            _MonthlyContent(state: state),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _MonthlyContent extends StatelessWidget {
  final MonthlyAnalyticsLoaded state;

  const _MonthlyContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // ── Trend Chart ──────────────────────────────────────────────────────
        Text('6-Month Trend', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: _TrendBarChart(chartData: state.chartData),
        ),
        const SizedBox(height: 28),

        // ── Variance Insights ────────────────────────────────────────────────
        if (state.variances.isNotEmpty) ...[
          Text('Period Insights', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          ...state.variances.take(5).map(
                (v) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _VarianceCard(insight: v),
                ),
              ),
          const SizedBox(height: 28),
        ],

        // ── Spending Leaks ───────────────────────────────────────────────────
        if (state.suggestions.isNotEmpty) ...[
          Row(
            children: [
              Text('Spending Leaks', style: AppTextStyles.headlineSmall),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${state.suggestions.length}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...state.suggestions.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SuggestionCard(suggestion: s),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Yearly View ──────────────────────────────────────────────────────────────

class _YearlyView extends StatelessWidget {
  const _YearlyView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return switch (state) {
          AnalyticsLoading() || AnalyticsInitial() =>
            const Center(child: CircularProgressIndicator()),
          AnalyticsError(:final message) => Center(child: Text(message)),
          YearlyAnalyticsLoaded() =>
            _YearlyContent(state: state),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _YearlyContent extends StatelessWidget {
  final YearlyAnalyticsLoaded state;

  const _YearlyContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final totalIncome = state.monthlySummaries.values
        .fold(0.0, (sum, s) => sum + s.totalIncome);
    final totalExpense = state.monthlySummaries.values
        .fold(0.0, (sum, s) => sum + s.totalExpense);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Year summary
        Row(
          children: [
            Expanded(
              child: _YearMetricCard(
                label: 'Total Income',
                amount: totalIncome,
                color: AppColors.income,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _YearMetricCard(
                label: 'Total Expenses',
                amount: totalExpense,
                color: AppColors.expense,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        Text('Monthly Breakdown', style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: _YearlyLineChart(monthlySummaries: state.monthlySummaries),
        ),
        const SizedBox(height: 28),

        if (state.variances.isNotEmpty) ...[
          Text('Year-over-Year Insights', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 12),
          ...state.variances.take(5).map(
                (v) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _VarianceCard(insight: v),
                ),
              ),
        ],
      ],
    );
  }
}

// ── Chart Widgets ─────────────────────────────────────────────────────────────

class _TrendBarChart extends StatelessWidget {
  final Map<DateTime, PeriodSummary> chartData;

  const _TrendBarChart({required this.chartData});

  @override
  Widget build(BuildContext context) {
    final sortedEntries = chartData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: sortedEntries.isEmpty
            ? 100
            : sortedEntries
                    .map((e) => e.value.totalExpense > e.value.totalIncome
                        ? e.value.totalExpense
                        : e.value.totalIncome)
                    .reduce((a, b) => a > b ? a : b) *
                1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final entry = sortedEntries[groupIndex];
              final label = rodIndex == 0 ? 'Income' : 'Expense';
              final amount = rodIndex == 0
                  ? entry.value.totalIncome
                  : entry.value.totalExpense;
              return BarTooltipItem(
                '$label\n${CurrencyFormatter.compact(amount)}',
                AppTextStyles.labelSmall.copyWith(color: Colors.white),
              );
            },
          ),
        ),
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
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= sortedEntries.length) {
                  return const SizedBox.shrink();
                }
                final month = sortedEntries[index].key;
                return Text(
                  DateFormat('MMM').format(month),
                  style: AppTextStyles.labelSmall,
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: sortedEntries.asMap().entries.map((entry) {
          final index = entry.key;
          final summary = entry.value.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: summary.totalIncome,
                color: AppColors.income,
                width: 10,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: summary.totalExpense,
                color: AppColors.expense,
                width: 10,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _YearlyLineChart extends StatelessWidget {
  final Map<int, PeriodSummary> monthlySummaries;

  const _YearlyLineChart({required this.monthlySummaries});

  @override
  Widget build(BuildContext context) {
    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];

    for (int m = 1; m <= 12; m++) {
      final summary = monthlySummaries[m];
      incomeSpots.add(FlSpot(m.toDouble(), summary?.totalIncome ?? 0));
      expenseSpots.add(FlSpot(m.toDouble(), summary?.totalExpense ?? 0));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            strokeWidth: 1,
          ),
        ),
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
              getTitlesWidget: (value, meta) {
                final months = [
                  'J', 'F', 'M', 'A', 'M', 'J',
                  'J', 'A', 'S', 'O', 'N', 'D',
                ];
                final index = value.toInt() - 1;
                if (index < 0 || index >= months.length) {
                  return const SizedBox.shrink();
                }
                return Text(months[index], style: AppTextStyles.labelSmall);
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: incomeSpots,
            isCurved: true,
            color: AppColors.income,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.income.withValues(alpha: 0.08),
            ),
          ),
          LineChartBarData(
            spots: expenseSpots,
            isCurved: true,
            color: AppColors.expense,
            barWidth: 2.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.expense.withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Insight Cards ─────────────────────────────────────────────────────────────

class _VarianceCard extends StatelessWidget {
  final VarianceInsight insight;

  const _VarianceCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    final isUp = insight.direction == VarianceDirection.up;
    final color = isUp ? AppColors.expense : AppColors.income;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(
            isUp ? Icons.trending_up : Icons.trending_down,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight.message,
              style: AppTextStyles.bodySmall.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            CurrencyFormatter.percent(insight.variancePercent),
            style: AppTextStyles.labelLarge.copyWith(color: color),
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
    final color = switch (suggestion.severity) {
      SuggestionSeverity.high => AppColors.danger,
      SuggestionSeverity.medium => AppColors.warning,
      SuggestionSeverity.low => AppColors.primary,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion.message,
            style: AppTextStyles.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Spent: ${CurrencyFormatter.full(suggestion.spent)}',
                style: AppTextStyles.labelSmall.copyWith(color: color),
              ),
              const SizedBox(width: 12),
              Text(
                'Budget: ${CurrencyFormatter.full(suggestion.threshold)}',
                style: AppTextStyles.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _YearMetricCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _YearMetricCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelSmall),
          const SizedBox(height: 6),
          Text(
            CurrencyFormatter.compact(amount),
            style: AppTextStyles.amountMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
