import '../../domain/entities/transaction.dart';
import '../../domain/entities/period_summary.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../local/database/app_database.dart';
import '../mappers/transaction_mapper.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase _db;

  const TransactionRepositoryImpl(this._db);

  @override
  Stream<List<Transaction>> watchByDateRange(DateTime start, DateTime end) =>
      _db.transactionDao.watchByDateRange(start, end).map(
        (rows) => rows.map(TransactionMapper.fromData).toList(),
      );

  @override
  Future<Either<Failure, List<Transaction>>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final rows = await _db.transactionDao.getByDateRange(start, end);
      return Right(rows.map(TransactionMapper.fromData).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getByCategoryId(
    String categoryId,
  ) async {
    try {
      final rows = await _db.transactionDao.getByCategoryId(categoryId);
      return Right(rows.map(TransactionMapper.fromData).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getById(String id) async {
    try {
      final row = await _db.transactionDao.getById(id);
      if (row == null) {
        return Left(NotFoundFailure('Transaction $id not found'));
      }
      return Right(TransactionMapper.fromData(row));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> create(Transaction transaction) async {
    try {
      await _db.transactionDao
          .insert(TransactionMapper.toCompanion(transaction));
      return Right(transaction);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> update(Transaction transaction) async {
    try {
      await _db.transactionDao
          .updateTransaction(TransactionMapper.toCompanion(transaction));
      return Right(transaction);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await _db.transactionDao.deleteById(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PeriodSummary>> getSummary(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final rows = await _db.transactionDao.getByDateRange(start, end);
      return Right(_buildSummary(rows, start, end));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<PeriodSummary> watchSummary(DateTime start, DateTime end) =>
      _db.transactionDao.watchByDateRange(start, end).map(
        (rows) => _buildSummary(rows, start, end),
      );

  PeriodSummary _buildSummary(
    List<dynamic> rows,
    DateTime start,
    DateTime end,
  ) {
    double totalIncome = 0;
    double totalExpense = 0;
    final expenseByCategory = <String, double>{};
    final incomeByCategory = <String, double>{};

    for (final row in rows) {
      final t = TransactionMapper.fromData(row);
      if (t.isIncome) {
        totalIncome += t.amount;
        incomeByCategory[t.categoryId] =
            (incomeByCategory[t.categoryId] ?? 0) + t.amount;
      } else {
        totalExpense += t.amount;
        expenseByCategory[t.categoryId] =
            (expenseByCategory[t.categoryId] ?? 0) + t.amount;
      }
    }

    return PeriodSummary(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      expenseByCategory: expenseByCategory,
      incomeByCategory: incomeByCategory,
      periodStart: start,
      periodEnd: end,
    );
  }
}
