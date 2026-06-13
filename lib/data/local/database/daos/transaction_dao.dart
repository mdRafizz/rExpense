import 'package:drift/drift.dart';

import '../app_database.dart';

class TransactionWithDetails {
  final TransactionTableData transaction;
  final CategoryTableData category;
  final AccountTableData account;
  final ContributorTableData? contributor;
  final BeneficiaryTableData? beneficiary;

  TransactionWithDetails({
    required this.transaction,
    required this.category,
    required this.account,
    this.contributor,
    this.beneficiary,
  });
}

class TransactionDao {
  final AppDatabase _db;

  const TransactionDao(this._db);

  // Insert transaction
  Future<int> insertTransaction({
    required double amount,
    required DateTime dateTime,
    required String transactionType,
    required int categoryId,
    required int accountId,
    String? notes,
    int? contributorId,
    int? beneficiaryId,
  }) async {
    return await _db.into(_db.transactionTable).insert(
          TransactionTableCompanion.insert(
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
          ),
        );
  }

  // Update transaction
  Future<bool> updateTransaction({
    required int id,
    double? amount,
    DateTime? dateTime,
    String? transactionType,
    int? categoryId,
    int? accountId,
    String? notes,
    int? contributorId,
    int? beneficiaryId,
  }) async {
    final existing = await getTransactionById(id);
    if (existing == null) return false;

    return await _db.update(_db.transactionTable).replace(
          TransactionTableData(
            id: id,
            amount: amount ?? existing.amount,
            transactionDate: dateTime ?? existing.transactionDate,
            notes: notes ?? existing.notes,
            transactionType: transactionType ?? existing.transactionType,
            categoryId: categoryId ?? existing.categoryId,
            contributorId: contributorId ?? existing.contributorId,
            beneficiaryId: beneficiaryId ?? existing.beneficiaryId,
            accountId: accountId ?? existing.accountId,
            createdAt: existing.createdAt,
          ),
        );
  }

  // Delete transaction
  Future<int> deleteTransaction(int id) {
    return (_db.delete(_db.transactionTable)..where((t) => t.id.equals(id)))
        .go();
  }

  // Get transaction by id
  Future<TransactionTableData?> getTransactionById(int id) {
    return (_db.select(_db.transactionTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Get all transactions with details
  Stream<List<TransactionWithDetails>> watchAllTransactionsWithDetails({
    DateTime? startDate,
    DateTime? endDate,
    String? transactionType,
    int? categoryId,
  }) {
    final query = _db.select(_db.transactionTable).join([
      innerJoin(_db.categoryTable,
          _db.categoryTable.id.equalsExp(_db.transactionTable.categoryId)),
      innerJoin(_db.accountTable,
          _db.accountTable.id.equalsExp(_db.transactionTable.accountId)),
      leftOuterJoin(
          _db.contributorTable,
          _db.contributorTable.id
              .equalsExp(_db.transactionTable.contributorId)),
      leftOuterJoin(
          _db.beneficiaryTable,
          _db.beneficiaryTable.id
              .equalsExp(_db.transactionTable.beneficiaryId)),
    ]);

    if (startDate != null) {
      query.where(
          _db.transactionTable.transactionDate.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where(
          _db.transactionTable.transactionDate.isSmallerOrEqualValue(endDate));
    }

    if (transactionType != null) {
      query.where(_db.transactionTable.transactionType.equals(transactionType));
    }

    if (categoryId != null) {
      query.where(_db.transactionTable.categoryId.equals(categoryId));
    }

    query.orderBy([
      OrderingTerm.desc(_db.transactionTable.transactionDate),
      OrderingTerm.desc(_db.transactionTable.createdAt),
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithDetails(
          transaction: row.readTable(_db.transactionTable),
          category: row.readTable(_db.categoryTable),
          account: row.readTable(_db.accountTable),
          contributor: row.readTableOrNull(_db.contributorTable),
          beneficiary: row.readTableOrNull(_db.beneficiaryTable),
        );
      }).toList();
    });
  }

  // Get transactions for today
  Stream<List<TransactionWithDetails>> watchTodayTransactions() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return watchAllTransactionsWithDetails(
      startDate: startOfDay,
      endDate: endOfDay,
    );
  }

  // Get net balance
  Future<double> getNetBalance({
    DateTime? start,
    DateTime? end,
    int? accountId,
  }) async {
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

    final transactions = await query.get();

    final totalIncome = transactions
        .where((t) => t.transactionType == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpense = transactions
        .where((t) => t.transactionType == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    return totalIncome - totalExpense;
  }

  // Get total income for period
  Future<double> getTotalIncome({
    DateTime? start,
    DateTime? end,
  }) async {
    var query = _db.select(_db.transactionTable)
      ..where((t) => t.transactionType.equals('income'));

    if (start != null) {
      query = query
        ..where((t) => t.transactionDate.isBiggerOrEqualValue(start));
    }

    if (end != null) {
      query = query..where((t) => t.transactionDate.isSmallerOrEqualValue(end));
    }

    final transactions = await query.get();
    final total = transactions.fold<double>(
      0.0,
          (double sum, t) => sum + t.amount,
    );

    return total;
  }

  // Get total expense for period
  Future<double> getTotalExpense({
    DateTime? start,
    DateTime? end,
  }) async {
    var query = _db.select(_db.transactionTable)
      ..where((t) => t.transactionType.equals('expense'));

    if (start != null) {
      query = query
        ..where((t) => t.transactionDate.isBiggerOrEqualValue(start));
    }

    if (end != null) {
      query = query..where((t) => t.transactionDate.isSmallerOrEqualValue(end));
    }

    final transactions = await query.get();
    final total =  transactions.fold(0.0, (sum, t) => sum + t.amount);
    return total;
  }

  // Get expenses by category
  Future<Map<int, double>> getExpensesByCategory({
    DateTime? start,
    DateTime? end,
  }) async {
    var query = _db.select(_db.transactionTable)
      ..where((t) => t.transactionType.equals('expense'));

    if (start != null) {
      query = query
        ..where((t) => t.transactionDate.isBiggerOrEqualValue(start));
    }

    if (end != null) {
      query = query..where((t) => t.transactionDate.isSmallerOrEqualValue(end));
    }

    final transactions = await query.get();
    final Map<int, double> categoryTotals = {};

    for (final transaction in transactions) {
      categoryTotals[transaction.categoryId] =
          (categoryTotals[transaction.categoryId] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }

  // Get daily expenses for period
  Future<Map<DateTime, double>> getDailyExpenses({
    required DateTime start,
    required DateTime end,
  }) async {
    final query = _db.select(_db.transactionTable)
      ..where((t) =>
          t.transactionType.equals('expense') &
          t.transactionDate.isBetweenValues(start, end));

    final transactions = await query.get();
    final Map<DateTime, double> dailyTotals = {};

    for (final transaction in transactions) {
      final date = DateTime(
        transaction.transactionDate.year,
        transaction.transactionDate.month,
        transaction.transactionDate.day,
      );
      dailyTotals[date] = (dailyTotals[date] ?? 0) + transaction.amount;
    }

    return dailyTotals;
  }
}

