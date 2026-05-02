import '../../domain/entities/budget.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../../core/logger/app_logger.dart';
import '../local/database/app_database.dart';
import '../mappers/budget_mapper.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  static const _tag = 'BudgetRepo';

  final AppDatabase _db;

  const BudgetRepositoryImpl(this._db);

  @override
  Stream<List<Budget>> watchByMonth(String month) {
    AppLogger.v(_tag, 'watchByMonth($month) subscribed');
    return _db.budgetDao.watchByMonth(month).map((rows) {
      final budgets = rows.map(BudgetMapper.fromData).toList();
      AppLogger.v(_tag, 'watchByMonth($month) emitted ${budgets.length} budgets');
      return budgets;
    });
  }

  @override
  Future<Either<Failure, List<Budget>>> getByMonth(String month) async {
    AppLogger.d(_tag, 'getByMonth($month)');
    try {
      final rows = await _db.budgetDao.getByMonth(month);
      AppLogger.d(_tag, 'getByMonth($month) → ${rows.length} rows');
      return Right(rows.map(BudgetMapper.fromData).toList());
    } catch (e, st) {
      AppLogger.e(_tag, 'getByMonth($month) failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget?>> getByCategoryAndMonth(
    String categoryId,
    String month,
  ) async {
    AppLogger.d(_tag, 'getByCategoryAndMonth(cat=$categoryId, month=$month)');
    try {
      final row = await _db.budgetDao.getByCategoryAndMonth(categoryId, month);
      AppLogger.d(_tag, 'getByCategoryAndMonth() → ${row != null ? 'found' : 'not found'}');
      return Right(row != null ? BudgetMapper.fromData(row) : null);
    } catch (e, st) {
      AppLogger.e(_tag, 'getByCategoryAndMonth() failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> create(Budget budget) async {
    AppLogger.i(_tag, 'create() id=${budget.id} cat=${budget.categoryId} limit=${budget.monthlyLimit} month=${budget.month}');
    try {
      await _db.budgetDao.insert(BudgetMapper.toCompanion(budget));
      AppLogger.i(_tag, 'create() success → ${budget.id}');
      return Right(budget);
    } catch (e, st) {
      AppLogger.e(_tag, 'create() failed for id=${budget.id}', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Budget>> update(Budget budget) async {
    AppLogger.i(_tag, 'update() id=${budget.id} limit=${budget.monthlyLimit}');
    try {
      await _db.budgetDao.updateBudget(BudgetMapper.toCompanion(budget));
      AppLogger.i(_tag, 'update() success → ${budget.id}');
      return Right(budget);
    } catch (e, st) {
      AppLogger.e(_tag, 'update() failed for id=${budget.id}', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    AppLogger.i(_tag, 'delete() id=$id');
    try {
      await _db.budgetDao.deleteById(id);
      AppLogger.i(_tag, 'delete() success → $id');
      return const Right(null);
    } catch (e, st) {
      AppLogger.e(_tag, 'delete() failed for id=$id', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
