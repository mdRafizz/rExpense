import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/period_summary.dart';
import '../../domain/entities/variance_insight.dart';
import '../../domain/entities/spending_suggestion.dart';
import '../../domain/usecases/calculate_variance.dart';
import '../../domain/usecases/detect_spending_leaks.dart';
import '../../domain/usecases/get_period_summary.dart';
import '../../core/utils/date_utils.dart';
import '../../core/constants/app_constants.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

/// BLoC that drives the analytics screen:
/// - Monthly/yearly summaries
/// - Period-over-period variance insights
/// - Spending-leak suggestions
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetPeriodSummary _getPeriodSummary;
  final CalculateVariance _calculateVariance;
  final DetectSpendingLeaks _detectSpendingLeaks;

  AnalyticsBloc({
    required GetPeriodSummary getPeriodSummary,
    required CalculateVariance calculateVariance,
    required DetectSpendingLeaks detectSpendingLeaks,
  })  : _getPeriodSummary = getPeriodSummary,
        _calculateVariance = calculateVariance,
        _detectSpendingLeaks = detectSpendingLeaks,
        super(const AnalyticsInitial()) {
    on<LoadMonthlyAnalytics>(_onLoadMonthly);
    on<LoadYearlyAnalytics>(_onLoadYearly);
  }

  Future<void> _onLoadMonthly(
    LoadMonthlyAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final year = event.year;
    final month = event.month;

    // Current period
    final currentStart = AppDateUtils.startOfMonth(year, month);
    final currentEnd = AppDateUtils.endOfMonth(year, month);

    // Previous period
    final prevDate = AppDateUtils.previousMonth(DateTime(year, month));
    final previousStart =
        AppDateUtils.startOfMonth(prevDate.year, prevDate.month);
    final previousEnd = AppDateUtils.endOfMonth(prevDate.year, prevDate.month);

    // Load last N months for chart
    final now = DateTime(year, month);
    final chartMonths = AppDateUtils.lastNMonths(
      now,
      AppConstants.monthlyChartMonths,
    );

    final chartSummaries = <DateTime, PeriodSummary>{};
    for (final m in chartMonths) {
      final s = AppDateUtils.startOfMonth(m.year, m.month);
      final e = AppDateUtils.endOfMonth(m.year, m.month);
      final result = await _getPeriodSummary.call(s, e);
      result.fold(
        (_) {},
        (summary) => chartSummaries[m] = summary,
      );
    }

    // Variance
    final varianceResult = await _calculateVariance.call(
      currentStart: currentStart,
      currentEnd: currentEnd,
      previousStart: previousStart,
      previousEnd: previousEnd,
    );

    // Spending leaks
    final leaksResult = await _detectSpendingLeaks.call(
      year: year,
      month: month,
    );

    final currentSummaryResult =
        await _getPeriodSummary.call(currentStart, currentEnd);

    if (currentSummaryResult.isLeft) {
      emit(AnalyticsError(currentSummaryResult.left.message));
      return;
    }

    emit(MonthlyAnalyticsLoaded(
      year: year,
      month: month,
      currentSummary: currentSummaryResult.right,
      chartData: chartSummaries,
      variances: varianceResult.isRight ? varianceResult.right : [],
      suggestions: leaksResult.isRight ? leaksResult.right : [],
    ));
  }

  Future<void> _onLoadYearly(
    LoadYearlyAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());

    final year = event.year;
    final monthlySummaries = <int, PeriodSummary>{};

    for (int m = 1; m <= 12; m++) {
      final start = AppDateUtils.startOfMonth(year, m);
      final end = AppDateUtils.endOfMonth(year, m);
      final result = await _getPeriodSummary.call(start, end);
      result.fold(
        (_) {},
        (summary) => monthlySummaries[m] = summary,
      );
    }

    // Year-over-year variance
    final currentYearStart = AppDateUtils.startOfYear(year);
    final currentYearEnd = AppDateUtils.endOfYear(year);
    final prevYearStart = AppDateUtils.startOfYear(year - 1);
    final prevYearEnd = AppDateUtils.endOfYear(year - 1);

    final varianceResult = await _calculateVariance.call(
      currentStart: currentYearStart,
      currentEnd: currentYearEnd,
      previousStart: prevYearStart,
      previousEnd: prevYearEnd,
    );

    emit(YearlyAnalyticsLoaded(
      year: year,
      monthlySummaries: monthlySummaries,
      variances: varianceResult.isRight ? varianceResult.right : [],
    ));
  }
}
