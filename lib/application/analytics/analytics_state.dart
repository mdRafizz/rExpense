part of 'analytics_bloc.dart';

sealed class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

final class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

final class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

final class MonthlyAnalyticsLoaded extends AnalyticsState {
  final int year;
  final int month;
  final PeriodSummary currentSummary;
  final Map<DateTime, PeriodSummary> chartData; // month -> summary
  final List<VarianceInsight> variances;
  final List<SpendingSuggestion> suggestions;

  /// Expense totals per memberId for the current month.
  final Map<String, double> expenseByMember;

  /// Expense totals per categoryId per memberId.
  /// Outer key = memberId, inner key = categoryId.
  final Map<String, Map<String, double>> expenseByCategoryPerMember;

  const MonthlyAnalyticsLoaded({
    required this.year,
    required this.month,
    required this.currentSummary,
    required this.chartData,
    required this.variances,
    required this.suggestions,
    required this.expenseByMember,
    required this.expenseByCategoryPerMember,
  });

  @override
  List<Object?> get props => [
        year,
        month,
        currentSummary,
        chartData,
        variances,
        suggestions,
        expenseByMember,
        expenseByCategoryPerMember,
      ];
}

final class YearlyAnalyticsLoaded extends AnalyticsState {
  final int year;
  final Map<int, PeriodSummary> monthlySummaries; // month number -> summary
  final List<VarianceInsight> variances;

  const YearlyAnalyticsLoaded({
    required this.year,
    required this.monthlySummaries,
    required this.variances,
  });

  @override
  List<Object?> get props => [year, monthlySummaries, variances];
}

final class AnalyticsError extends AnalyticsState {
  final String message;
  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
