import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/period_summary.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../core/utils/date_utils.dart';

part 'dashboard_state.dart';

/// Drives the main dashboard — reactive monthly summary + transaction list.
class DashboardCubit extends Cubit<DashboardState> {
  final TransactionRepository _repository;

  StreamSubscription<PeriodSummary>? _summarySubscription;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;

  DateTime _selectedMonth;

  DashboardCubit(this._repository)
      : _selectedMonth = DateTime.now(),
        super(const DashboardLoading()) {
    _subscribe();
  }

  DateTime get selectedMonth => _selectedMonth;

  void selectMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month, 1);
    _subscribe();
  }

  void nextMonth() => selectMonth(AppDateUtils.nextMonth(_selectedMonth));
  void previousMonth() =>
      selectMonth(AppDateUtils.previousMonth(_selectedMonth));

  void _subscribe() {
    _summarySubscription?.cancel();
    _transactionsSubscription?.cancel();

    final start = AppDateUtils.startOfMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    final end = AppDateUtils.endOfMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );

    // Combine both streams
    PeriodSummary? latestSummary;
    List<Transaction>? latestTransactions;

    void tryEmit() {
      if (latestSummary != null && latestTransactions != null) {
        emit(DashboardLoaded(
          summary: latestSummary!,
          transactions: latestTransactions!,
          selectedMonth: _selectedMonth,
        ));
      }
    }

    _summarySubscription =
        _repository.watchSummary(start, end).listen((summary) {
      latestSummary = summary;
      tryEmit();
    });

    _transactionsSubscription =
        _repository.watchByDateRange(start, end).listen((transactions) {
      latestTransactions = transactions;
      tryEmit();
    });
  }

  @override
  Future<void> close() {
    _summarySubscription?.cancel();
    _transactionsSubscription?.cancel();
    return super.close();
  }
}
