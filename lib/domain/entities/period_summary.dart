import 'package:equatable/equatable.dart';

/// Aggregated financial summary for a time period.
class PeriodSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final Map<String, double> expenseByCategory; // categoryId -> amount
  final Map<String, double> incomeByCategory;
  final DateTime periodStart;
  final DateTime periodEnd;

  const PeriodSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.expenseByCategory,
    required this.incomeByCategory,
    required this.periodStart,
    required this.periodEnd,
  });

  double get netBalance => totalIncome - totalExpense;
  double get savingsRate =>
      totalIncome > 0 ? (netBalance / totalIncome) * 100 : 0;

  static final PeriodSummary empty = PeriodSummary(
    totalIncome: 0,
    totalExpense: 0,
    expenseByCategory: const {},
    incomeByCategory: const {},
    periodStart: DateTime.utc(1970),
    periodEnd: DateTime.utc(1970),
  );

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        expenseByCategory,
        incomeByCategory,
        periodStart,
        periodEnd,
      ];
}
