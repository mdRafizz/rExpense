part of 'dashboard_cubit.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  final PeriodSummary summary;
  final List<Transaction> transactions;
  final DateTime selectedMonth;

  const DashboardLoaded({
    required this.summary,
    required this.transactions,
    required this.selectedMonth,
  });

  @override
  List<Object?> get props => [summary, transactions, selectedMonth];
}

final class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
