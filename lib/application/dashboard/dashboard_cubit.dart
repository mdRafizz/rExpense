import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/period_summary.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../core/utils/date_utils.dart';
import '../../core/logger/app_logger.dart';

part 'dashboard_state.dart';

/// Drives the main dashboard — reactive monthly summary + transaction list.
class DashboardCubit extends Cubit<DashboardState> {
  static const _tag = 'DashboardCubit';

  final TransactionRepository _repository;

  StreamSubscription<PeriodSummary>? _summarySubscription;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;

  DateTime _selectedMonth;

  DashboardCubit(this._repository)
      : _selectedMonth = DateTime.now(),
        super(const DashboardLoading()) {
    AppLogger.d(_tag, 'created — subscribing to ${AppDateUtils.toMonthKey(DateTime.now())}');
    _subscribe();
  }

  DateTime get selectedMonth => _selectedMonth;

  void selectMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month, 1);
    AppLogger.d(_tag, 'selectMonth() → ${AppDateUtils.toMonthKey(_selectedMonth)}');
    _subscribe();
  }

  void nextMonth() => selectMonth(AppDateUtils.nextMonth(_selectedMonth));
  void previousMonth() => selectMonth(AppDateUtils.previousMonth(_selectedMonth));

  void _subscribe() {
    _summarySubscription?.cancel();
    _transactionsSubscription?.cancel();

    final start = AppDateUtils.startOfMonth(_selectedMonth.year, _selectedMonth.month);
    final end   = AppDateUtils.endOfMonth(_selectedMonth.year, _selectedMonth.month);
    AppLogger.d(_tag, '_subscribe() range [$start → $end]');

    PeriodSummary? latestSummary;
    List<Transaction>? latestTransactions;

    void tryEmit() {
      if (latestSummary != null && latestTransactions != null) {
        AppLogger.d(_tag,
          'tryEmit() → ${latestTransactions!.length} txns '
          'income=${latestSummary!.totalIncome} '
          'expense=${latestSummary!.totalExpense}',
        );
        emit(DashboardLoaded(
          summary: latestSummary!,
          transactions: latestTransactions!,
          selectedMonth: _selectedMonth,
        ));
      }
    }

    _summarySubscription = _repository.watchSummary(start, end).listen(
      (summary) {
        latestSummary = summary;
        tryEmit();
      },
      onError: (e, st) => AppLogger.e(_tag, 'watchSummary() stream error', error: e, stackTrace: st),
    );

    _transactionsSubscription = _repository.watchByDateRange(start, end).listen(
      (transactions) {
        latestTransactions = transactions;
        tryEmit();
      },
      onError: (e, st) => AppLogger.e(_tag, 'watchByDateRange() stream error', error: e, stackTrace: st),
    );
  }

  @override
  Future<void> close() {
    AppLogger.d(_tag, 'close() — cancelling subscriptions');
    _summarySubscription?.cancel();
    _transactionsSubscription?.cancel();
    return super.close();
  }
}
