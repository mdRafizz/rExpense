import '../entities/budget.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import 'category_repository.dart';

/// Contract for budget persistence.
abstract interface class BudgetRepository {
  /// Reactively emits all budgets for a given month (YYYY-MM).
  Stream<List<Budget>> watchByMonth(String month);

  /// Returns all budgets for a given month.
  Future<Either<Failure, List<Budget>>> getByMonth(String month);

  /// Returns the budget for a specific category and month.
  Future<Either<Failure, Budget?>> getByCategoryAndMonth(
    String categoryId,
    String month,
  );

  /// Persists a new budget.
  Future<Either<Failure, Budget>> create(Budget budget);

  /// Updates an existing budget.
  Future<Either<Failure, Budget>> update(Budget budget);

  /// Deletes a budget by id.
  Future<Either<Failure, Unit>> delete(String id);
}
