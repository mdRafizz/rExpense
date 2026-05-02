import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/transactions_table.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [TransactionsTable])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  /// Reactively emits transactions within a date range, newest first.
  Stream<List<TransactionsTableData>> watchByDateRange(
    DateTime start,
    DateTime end,
  ) =>
      (select(transactionsTable)
            ..where((t) => t.date.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .watch();

  /// Returns transactions within a date range once.
  Future<List<TransactionsTableData>> getByDateRange(
    DateTime start,
    DateTime end,
  ) =>
      (select(transactionsTable)
            ..where((t) => t.date.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Returns all transactions for a category.
  Future<List<TransactionsTableData>> getByCategoryId(String categoryId) =>
      (select(transactionsTable)
            ..where((t) => t.categoryId.equals(categoryId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  /// Returns a single transaction by id.
  Future<TransactionsTableData?> getById(String id) =>
      (select(transactionsTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Inserts a new transaction.
  Future<void> insert(TransactionsTableCompanion companion) =>
      into(transactionsTable).insert(companion);

  /// Updates an existing transaction.
  Future<bool> updateTransaction(TransactionsTableCompanion companion) =>
      update(transactionsTable).replace(companion);

  /// Deletes a transaction by id.
  Future<int> deleteById(String id) =>
      (delete(transactionsTable)..where((t) => t.id.equals(id))).go();

  /// Aggregates totals for a date range.
  Future<Map<String, double>> getExpenseByCategory(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await (select(transactionsTable)
          ..where((t) =>
              t.date.isBetweenValues(start, end) &
              t.type.equals('expense')))
        .get();

    final map = <String, double>{};
    for (final row in rows) {
      map[row.categoryId] = (map[row.categoryId] ?? 0) + row.amount;
    }
    return map;
  }

  Future<Map<String, double>> getIncomeByCategory(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await (select(transactionsTable)
          ..where((t) =>
              t.date.isBetweenValues(start, end) &
              t.type.equals('income')))
        .get();

    final map = <String, double>{};
    for (final row in rows) {
      map[row.categoryId] = (map[row.categoryId] ?? 0) + row.amount;
    }
    return map;
  }

  /// Returns expense totals grouped by memberId for a date range.
  /// Key is memberId (null → 'family').
  Future<Map<String, double>> getExpenseByMember(
    DateTime start,
    DateTime end,
  ) async {
    final rows = await (select(transactionsTable)
          ..where((t) =>
              t.date.isBetweenValues(start, end) &
              t.type.equals('expense')))
        .get();

    final map = <String, double>{};
    for (final row in rows) {
      final key = row.memberId ?? 'member_family';
      map[key] = (map[key] ?? 0) + row.amount;
    }
    return map;
  }

  /// Returns expense totals per category for a specific member.
  Future<Map<String, double>> getExpenseByCategoryForMember(
    DateTime start,
    DateTime end,
    String memberId,
  ) async {
    final rows = await (select(transactionsTable)
          ..where((t) =>
              t.date.isBetweenValues(start, end) &
              t.type.equals('expense') &
              t.memberId.equals(memberId)))
        .get();

    final map = <String, double>{};
    for (final row in rows) {
      map[row.categoryId] = (map[row.categoryId] ?? 0) + row.amount;
    }
    return map;
  }
}
