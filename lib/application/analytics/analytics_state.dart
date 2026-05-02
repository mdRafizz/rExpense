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

  const MonthlyAnalyticsLoaded({
    required this.year,
    required this.month,
    required this.currentSummary,
    required this.chartData,
    required this.variances,
    required this.suggestions,
  });

  @override
  List<Object?> get props =>
      [year, month, currentSummary, chartData, variances, suggestions];
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
