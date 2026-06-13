import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/database/daos/transaction_dao.dart';
import 'database_provider.dart';

part 'transaction_providers.g.dart';

// Watch today's transactions
@riverpod
Stream<List<TransactionWithDetails>> todayTransactions(
  TodayTransactionsRef ref,
) {
  final dao = ref.watch(transactionDaoProvider);
  return dao.watchTodayTransactions();
}

// Watch all transactions with optional filters
@riverpod
Stream<List<TransactionWithDetails>> allTransactions(
  AllTransactionsRef ref, {
  DateTime? startDate,
  DateTime? endDate,
  String? transactionType,
  int? categoryId,
}) {
  final dao = ref.watch(transactionDaoProvider);
  return dao.watchAllTransactionsWithDetails(
    startDate: startDate,
    endDate: endDate,
    transactionType: transactionType,
    categoryId: categoryId,
  );
}

// Get net balance
@riverpod
Future<double> netBalance(
  NetBalanceRef ref, {
  DateTime? start,
  DateTime? end,
}) async {
  final dao = ref.watch(transactionDaoProvider);
  return dao.getNetBalance(start: start, end: end);
}

// Get monthly income
@riverpod
Future<double> monthlyIncome(MonthlyIncomeRef ref) async {
  final dao = ref.watch(transactionDaoProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  
  return dao.getTotalIncome(start: startOfMonth, end: endOfMonth);
}

// Get monthly expense
@riverpod
Future<double> monthlyExpense(MonthlyExpenseRef ref) async {
  final dao = ref.watch(transactionDaoProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  
  return dao.getTotalExpense(start: startOfMonth, end: endOfMonth);
}

// Get expenses by category
@riverpod
Future<Map<int, double>> expensesByCategory(
  ExpensesByCategoryRef ref, {
  DateTime? start,
  DateTime? end,
}) async {
  final dao = ref.watch(transactionDaoProvider);
  return dao.getExpensesByCategory(start: start, end: end);
}

// Get daily expenses
@riverpod
Future<Map<DateTime, double>> dailyExpenses(
  DailyExpensesRef ref, {
  required DateTime start,
  required DateTime end,
}) async {
  final dao = ref.watch(transactionDaoProvider);
  return dao.getDailyExpenses(start: start, end: end);
}
