import 'package:uuid/uuid.dart';
import '../entities/budget.dart';
import '../repositories/budget_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../../core/utils/date_utils.dart';

/// Use-cases for budget CRUD operations.
class ManageBudgets {
  final BudgetRepository _repository;
  final _uuid = const Uuid();

  ManageBudgets(this._repository);

  Stream<List<Budget>> watchByMonth(String month) =>
      _repository.watchByMonth(month);

  Future<Either<Failure, List<Budget>>> getByMonth(String month) =>
      _repository.getByMonth(month);

  Future<Either<Failure, Budget>> setMonthlyBudget({
    required String categoryId,
    required double limit,
    required int year,
    required int month,
  }) async {
    if (limit <= 0) {
      return Future.value(
        Left(const ValidationFailure('Budget limit must be positive')),
      );
    }

    final monthKey = AppDateUtils.toMonthKey(DateTime(year, month));
    final existing =
        await _repository.getByCategoryAndMonth(categoryId, monthKey);

    if (existing.isLeft) return Left(existing.left);

    final now = DateTime.now();

    if (existing.right != null) {
      // Update existing
      return _repository.update(
        existing.right!.copyWith(monthlyLimit: limit, updatedAt: now),
      );
    } else {
      // Create new
      final budget = Budget(
        id: _uuid.v4(),
        categoryId: categoryId,
        monthlyLimit: limit,
        month: monthKey,
        createdAt: now,
        updatedAt: now,
      );
      return _repository.create(budget);
    }
  }

  Future<Either<Failure, void>> delete(String id) =>
      _repository.delete(id);
}
