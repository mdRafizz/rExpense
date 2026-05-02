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
import '../../core/logger/app_logger.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

/// BLoC that drives the analytics screen:
/// - Monthly/yearly summaries
/// - Period-over-period variance insights
/// - Spending-leak suggestions
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  static const _tag = 'AnalyticsBloc';

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
    AppLogger.i(_tag, '_onLoadMonthly() year=${event.year} month=${event.month}');
    emit(const AnalyticsLoading());

    final year  = event.year;
    final month = event.month;

    final currentStart  = AppDateUtils.startOfMonth(year, month);
    final currentEnd    = AppDateUtils.endOfMonth(year, month);
    final prevDate      = AppDateUtils.previousMonth(DateTime(year, month));
    final previousStart = AppDateUtils.startOfMonth(prevDate.year, prevDate.month);
    final previousEnd   = AppDateUtils.endOfMonth(prevDate.year, prevDate.month);

    // Chart data — last N months
    final chartMonths = AppDateUtils.lastNMonths(
      DateTime(year, month),
      AppConstants.monthlyChartMonths,
    );
    AppLogger.d(_tag, 'loading chart data for ${chartMonths.length} months');

    final chartSummaries = <DateTime, PeriodSummary>{};
    for (final m in chartMonths) {
      final s = AppDateUtils.startOfMonth(m.year, m.month);
      final e = AppDateUtils.endOfMonth(m.year, m.month);
      final result = await _getPeriodSummary.call(s, e);
      result.fold(
        (failure) => AppLogger.w(_tag, 'chart month ${AppDateUtils.toMonthKey(m)} failed → ${failure.message}'),
        (summary) {
          chartSummaries[m] = summary;
          AppLogger.v(_tag, 'chart month ${AppDateUtils.toMonthKey(m)} → income=${summary.totalIncome} expense=${summary.totalExpense}');
        },
      );
    }

    // Variance
    AppLogger.d(_tag, 'calculating variance');
    final varianceResult = await _calculateVariance.call(
      currentStart: currentStart,
      currentEnd: currentEnd,
      previousStart: previousStart,
      previousEnd: previousEnd,
    );
    varianceResult.fold(
      (f) => AppLogger.w(_tag, 'variance calculation failed → ${f.message}'),
      (v) => AppLogger.i(_tag, 'variance → ${v.length} insights'),
    );

    // Spending leaks
    AppLogger.d(_tag, 'detecting spending leaks');
    final leaksResult = await _detectSpendingLeaks.call(year: year, month: month);
    leaksResult.fold(
      (f) => AppLogger.w(_tag, 'spending leak detection failed → ${f.message}'),
      (s) => AppLogger.i(_tag, 'spending leaks → ${s.length} suggestions'),
    );

    // Current summary
    final currentSummaryResult = await _getPeriodSummary.call(currentStart, currentEnd);
    if (currentSummaryResult.isLeft) {
      AppLogger.e(_tag, '_onLoadMonthly() current summary failed → ${currentSummaryResult.left.message}');
      emit(AnalyticsError(currentSummaryResult.left.message));
      return;
    }

    AppLogger.i(_tag, '_onLoadMonthly() complete — emitting MonthlyAnalyticsLoaded');
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
    AppLogger.i(_tag, '_onLoadYearly() year=${event.year}');
    emit(const AnalyticsLoading());

    final year = event.year;
    final monthlySummaries = <int, PeriodSummary>{};

    for (int m = 1; m <= 12; m++) {
      final start = AppDateUtils.startOfMonth(year, m);
      final end   = AppDateUtils.endOfMonth(year, m);
      final result = await _getPeriodSummary.call(start, end);
      result.fold(
        (f) => AppLogger.w(_tag, 'yearly month $m failed → ${f.message}'),
        (summary) {
          monthlySummaries[m] = summary;
          AppLogger.v(_tag, 'yearly month $m → income=${summary.totalIncome} expense=${summary.totalExpense}');
        },
      );
    }

    // Year-over-year variance
    AppLogger.d(_tag, 'calculating year-over-year variance');
    final varianceResult = await _calculateVariance.call(
      currentStart: AppDateUtils.startOfYear(year),
      currentEnd:   AppDateUtils.endOfYear(year),
      previousStart: AppDateUtils.startOfYear(year - 1),
      previousEnd:   AppDateUtils.endOfYear(year - 1),
    );
    varianceResult.fold(
      (f) => AppLogger.w(_tag, 'YoY variance failed → ${f.message}'),
      (v) => AppLogger.i(_tag, 'YoY variance → ${v.length} insights'),
    );

    AppLogger.i(_tag, '_onLoadYearly() complete — emitting YearlyAnalyticsLoaded');
    emit(YearlyAnalyticsLoaded(
      year: year,
      monthlySummaries: monthlySummaries,
      variances: varianceResult.isRight ? varianceResult.right : [],
    ));
  }
}
