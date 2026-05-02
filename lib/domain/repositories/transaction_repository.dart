import '../entities/transaction.dart';
import '../entities/period_summary.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import 'category_repository.dart';

/// Contract for transaction persistence and aggregation.
abstract interface class TransactionRepository {
  /// Reactively emits transactions for a date range.
  Stream<List<Transaction>> watchByDateRange(DateTime start, DateTime end);

  /// Returns transactions for a date range once.
  Future<Either<Failure, List<Transaction>>> getByDateRange(
    DateTime start,
    DateTime end,
  );

  /// Returns all transactions for a specific category.
  Future<Either<Failure, List<Transaction>>> getByCategoryId(String categoryId);

  /// Returns a single transaction by id.
  Future<Either<Failure, Transaction>> getById(String id);

  /// Persists a new transaction.
  Future<Either<Failure, Transaction>> create(Transaction transaction);

  /// Updates an existing transaction.
  Future<Either<Failure, Transaction>> update(Transaction transaction);

  /// Deletes a transaction by id.
  Future<Either<Failure, Unit>> delete(String id);

  /// Aggregates income/expense totals and per-category breakdowns.
  Future<Either<Failure, PeriodSummary>> getSummary(
    DateTime start,
    DateTime end,
  );

  /// Reactively emits the summary for a date range.
  Stream<PeriodSummary> watchSummary(DateTime start, DateTime end);
}
