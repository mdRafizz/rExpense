import '../../domain/entities/transaction.dart';
import '../../domain/entities/period_summary.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../../core/logger/app_logger.dart';
import '../local/database/app_database.dart';
import '../mappers/transaction_mapper.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  static const _tag = 'TransactionRepo';

  final AppDatabase _db;

  const TransactionRepositoryImpl(this._db);

  @override
  Stream<List<Transaction>> watchByDateRange(DateTime start, DateTime end) {
    AppLogger.v(_tag, 'watchByDateRange() subscribed [$start → $end]');
    return _db.transactionDao.watchByDateRange(start, end).map((rows) {
      final txns = rows.map(TransactionMapper.fromData).toList();
      AppLogger.v(_tag, 'watchByDateRange() emitted ${txns.length} transactions');
      return txns;
    });
  }

  @override
  Future<Either<Failure, List<Transaction>>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    AppLogger.d(_tag, 'getByDateRange() [$start → $end]');
    try {
      final rows = await _db.transactionDao.getByDateRange(start, end);
      AppLogger.d(_tag, 'getByDateRange() → ${rows.length} rows');
      return Right(rows.map(TransactionMapper.fromData).toList());
    } catch (e, st) {
      AppLogger.e(_tag, 'getByDateRange() failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getByCategoryId(
    String categoryId,
  ) async {
    AppLogger.d(_tag, 'getByCategoryId($categoryId)');
    try {
      final rows = await _db.transactionDao.getByCategoryId(categoryId);
      AppLogger.d(_tag, 'getByCategoryId($categoryId) → ${rows.length} rows');
      return Right(rows.map(TransactionMapper.fromData).toList());
    } catch (e, st) {
      AppLogger.e(_tag, 'getByCategoryId($categoryId) failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getById(String id) async {
    AppLogger.d(_tag, 'getById($id)');
    try {
      final row = await _db.transactionDao.getById(id);
      if (row == null) {
        AppLogger.w(_tag, 'getById($id) → not found');
        return Left(NotFoundFailure('Transaction $id not found'));
      }
      AppLogger.d(_tag, 'getById($id) → found');
      return Right(TransactionMapper.fromData(row));
    } catch (e, st) {
      AppLogger.e(_tag, 'getById($id) failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> create(Transaction transaction) async {
    AppLogger.i(_tag, 'create() id=${transaction.id} amount=${transaction.amount} type=${transaction.type.name}');
    try {
      await _db.transactionDao.insert(TransactionMapper.toCompanion(transaction));
      AppLogger.i(_tag, 'create() success → ${transaction.id}');
      return Right(transaction);
    } catch (e, st) {
      AppLogger.e(_tag, 'create() failed for id=${transaction.id}', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> update(Transaction transaction) async {
    AppLogger.i(_tag, 'update() id=${transaction.id}');
    try {
      await _db.transactionDao.updateTransaction(TransactionMapper.toCompanion(transaction));
      AppLogger.i(_tag, 'update() success → ${transaction.id}');
      return Right(transaction);
    } catch (e, st) {
      AppLogger.e(_tag, 'update() failed for id=${transaction.id}', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    AppLogger.i(_tag, 'delete() id=$id');
    try {
      await _db.transactionDao.deleteById(id);
      AppLogger.i(_tag, 'delete() success → $id');
      return const Right(null);
    } catch (e, st) {
      AppLogger.e(_tag, 'delete() failed for id=$id', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PeriodSummary>> getSummary(
    DateTime start,
    DateTime end,
  ) async {
    AppLogger.d(_tag, 'getSummary() [$start → $end]');
    try {
      final rows = await _db.transactionDao.getByDateRange(start, end);
      final summary = _buildSummary(rows, start, end);
      AppLogger.d(_tag,
        'getSummary() → income=${summary.totalIncome} '
        'expense=${summary.totalExpense} '
        'categories=${summary.expenseByCategory.length}',
      );
      return Right(summary);
    } catch (e, st) {
      AppLogger.e(_tag, 'getSummary() failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<PeriodSummary> watchSummary(DateTime start, DateTime end) {
    AppLogger.v(_tag, 'watchSummary() subscribed [$start → $end]');
    return _db.transactionDao.watchByDateRange(start, end).map(
      (rows) => _buildSummary(rows, start, end),
    );
  }

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

  @override
  Future<Either<Failure, Map<String, double>>> getExpenseByMember(
    DateTime start,
    DateTime end,
  ) async {
    AppLogger.d(_tag, 'getExpenseByMember() [$start → $end]');
    try {
      final map = await _db.transactionDao.getExpenseByMember(start, end);
      return Right(map);
    } catch (e, st) {
      AppLogger.e(_tag, 'getExpenseByMember() failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getExpenseByCategoryForMember(
    DateTime start,
    DateTime end,
    String memberId,
  ) async {
    AppLogger.d(_tag, 'getExpenseByCategoryForMember() member=$memberId');
    try {
      final map = await _db.transactionDao
          .getExpenseByCategoryForMember(start, end, memberId);
      return Right(map);
    } catch (e, st) {
      AppLogger.e(_tag, 'getExpenseByCategoryForMember() failed',
          error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
