import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/period_summary.dart';
import '../../domain/entities/variance_insight.dart';
import '../../domain/entities/spending_suggestion.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/repositories/member_repository.dart';
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
/// - Member expense breakdown
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  static const _tag = 'AnalyticsBloc';

  final GetPeriodSummary _getPeriodSummary;
  final CalculateVariance _calculateVariance;
  final DetectSpendingLeaks _detectSpendingLeaks;
  final TransactionRepository _transactionRepository;
  final MemberRepository _memberRepository;

  AnalyticsBloc({
    required GetPeriodSummary getPeriodSummary,
    required CalculateVariance calculateVariance,
    required DetectSpendingLeaks detectSpendingLeaks,
    required TransactionRepository transactionRepository,
    required MemberRepository memberRepository,
  })  : _getPeriodSummary = getPeriodSummary,
        _calculateVariance = calculateVariance,
        _detectSpendingLeaks = detectSpendingLeaks,
        _transactionRepository = transactionRepository,
        _memberRepository = memberRepository,
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

    final chartSummaries = <DateTime, PeriodSummary>{};
    for (final m in chartMonths) {
      final s = AppDateUtils.startOfMonth(m.year, m.month);
      final e = AppDateUtils.endOfMonth(m.year, m.month);
      final result = await _getPeriodSummary.call(s, e);
      result.fold(
        (failure) => AppLogger.w(_tag, 'chart month failed → ${failure.message}'),
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
    final leaksResult = await _detectSpendingLeaks.call(year: year, month: month);

    // Current summary
    final currentSummaryResult = await _getPeriodSummary.call(currentStart, currentEnd);
    if (currentSummaryResult.isLeft) {
      emit(AnalyticsError(currentSummaryResult.left.message));
      return;
    }

    // Member breakdown
    final memberExpenseResult = await _transactionRepository
        .getExpenseByMember(currentStart, currentEnd);
    final expenseByMember = memberExpenseResult.isRight
        ? memberExpenseResult.right
        : <String, double>{};

    // Per-member category breakdown
    final membersResult = await _memberRepository.getAll();
    final members = membersResult.isRight ? membersResult.right : [];
    final expenseByCategoryPerMember = <String, Map<String, double>>{};
    for (final member in members) {
      final catResult = await _transactionRepository
          .getExpenseByCategoryForMember(currentStart, currentEnd, member.id);
      if (catResult.isRight && catResult.right.isNotEmpty) {
        expenseByCategoryPerMember[member.id] = catResult.right;
      }
    }

    // Daily expense breakdown for the current month
    final dailyExpenses = <int, double>{};
    final txnsResult = await _transactionRepository.getByDateRange(currentStart, currentEnd);
    if (txnsResult.isRight) {
      for (final t in txnsResult.right) {
        if (!t.isIncome) {
          final day = t.date.day;
          dailyExpenses[day] = (dailyExpenses[day] ?? 0) + t.amount;
        }
      }
    }

    AppLogger.i(_tag, '_onLoadMonthly() complete');
    emit(MonthlyAnalyticsLoaded(
      year: year,
      month: month,
      currentSummary: currentSummaryResult.right,
      chartData: chartSummaries,
      variances: varianceResult.isRight ? varianceResult.right : [],
      suggestions: leaksResult.isRight ? leaksResult.right : [],
      expenseByMember: expenseByMember,
      expenseByCategoryPerMember: expenseByCategoryPerMember,
      dailyExpenses: dailyExpenses,
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
        (summary) => monthlySummaries[m] = summary,
      );
    }

    final varianceResult = await _calculateVariance.call(
      currentStart: AppDateUtils.startOfYear(year),
      currentEnd:   AppDateUtils.endOfYear(year),
      previousStart: AppDateUtils.startOfYear(year - 1),
      previousEnd:   AppDateUtils.endOfYear(year - 1),
    );

    emit(YearlyAnalyticsLoaded(
      year: year,
      monthlySummaries: monthlySummaries,
      variances: varianceResult.isRight ? varianceResult.right : [],
    ));
  }
}
