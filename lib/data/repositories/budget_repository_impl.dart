import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../local/database/app_database.dart';
import '../mappers/budget_mapper.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final AppDatabase _db;

  const BudgetRepositoryImpl(this._db);

  @override
  Stream<List<Budget>> watchByMonth(String month) =>
      _db.budgetDao.watchByMonth(month).map(
        (rows) => rows.map(BudgetMapper.fromData).toList(),
      );

  @override
  Future<Either<Failure, List<Budget>>> getByMonth(String month) async {
    try {
      final rows = await _db.budgetDao.getByMonth(month);
      return Right(rows.map(BudgetMapper.fromData).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget?>> getByCategoryAndMonth(
    String categoryId,
    String month,
  ) async {
    try {
      final row =
          await _db.budgetDao.getByCategoryAndMonth(categoryId, month);
      return Right(row != null ? BudgetMapper.fromData(row) : null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> create(Budget budget) async {
    try {
      await _db.budgetDao.insert(BudgetMapper.toCompanion(budget));
      return Right(budget);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> update(Budget budget) async {
    try {
      await _db.budgetDao.updateBudget(BudgetMapper.toCompanion(budget));
      return Right(budget);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await _db.budgetDao.deleteById(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
