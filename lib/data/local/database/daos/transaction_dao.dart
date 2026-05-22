import 'package:drift/drift.dart';
import 'package:rexpense/core/utils/date_utils.dart';

import '../app_database.dart';

class TransactionDao {
  final AppDatabase _db;

  const TransactionDao(this._db);

  Future<void> insertTransaction({
    required double amount,
    required DateTime dateTime,
    required String transactionType,
    required int categoryId,
    required int accountId,
    String? notes,
    int? contributorId,
    int? beneficiaryId,
  }) async {
    await _db
        .into(_db.transactionTable)
        .insert(TransactionTableCompanion.insert(
          amount: Value(amount),
          transactionDate: dateTime,
          transactionType: transactionType,
          categoryId: categoryId,
          accountId: accountId,
          notes: notes != null ? Value(notes) : const Value.absent(),
          contributorId: contributorId != null
              ? Value(contributorId)
              : const Value.absent(),
          beneficiaryId: beneficiaryId != null
              ? Value(beneficiaryId)
              : const Value.absent(),
        ));
  }

  Future<double> getNetBalance(
      {DateTime? start, DateTime? end, int? accountId}) async {
    var query = _db.select(_db.transactionTable);

    if (start != null) {
      query = query
        ..where((t) => t.transactionDate.isBiggerOrEqualValue(start));
    }

    if (end != null) {
      query = query..where((t) => t.transactionDate.isSmallerOrEqualValue(end));
    }

    if (accountId != null) {
      query = query..where((t) => t.accountId.equals(accountId));
    }

    final transaction = await query.get();

    final totalIncome = transaction
        .where((t) => t.transactionType == "income")
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpense = transaction
        .where((t) => t.transactionType == "expense")
        .fold(0.0, (sum, t) => sum + t.amount);

    return totalIncome - totalExpense;
  }

  // Get expenses by category for a month
  Future<Map<String, double>> getExpenseByCategoryForMonth(
      DateTime month) async {
    final start = AppDateUtils.startOfMonth(month.year, month.month);
    final end = AppDateUtils.endOfMonth(month.year, month.month);

    final query = _db.select(_db.transactionTable).join([
      innerJoin(_db.categoryTable,
          _db.categoryTable.id.equalsExp(_db.transactionTable.categoryId))
    ]);

    query.where(_db.transactionTable.transactionType.equals("expense") &
        _db.transactionTable.transactionDate.isBetweenValues(start, end));

    final results = await query.get();

    final Map<String, double> categoryTotals = {};

    for (final row in results) {
      final category = row.readTable(_db.categoryTable);
      final transaction = row.readTable(_db.transactionTable);

      categoryTotals[category.name] =
          (categoryTotals[category.name] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }
}
