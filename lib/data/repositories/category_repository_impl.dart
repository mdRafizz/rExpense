import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../../core/logger/app_logger.dart';
import '../local/database/app_database.dart';
import '../mappers/category_mapper.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  static const _tag = 'CategoryRepo';

  final AppDatabase _db;

  const CategoryRepositoryImpl(this._db);

  @override
  Stream<List<Category>> watchAll() {
    AppLogger.v(_tag, 'watchAll() stream subscribed');
    return _db.categoryDao.watchAll().map((rows) {
      final categories = rows.map(CategoryMapper.fromData).toList();
      AppLogger.v(_tag, 'watchAll() emitted ${categories.length} categories');
      return categories;
    });
  }

  @override
  Future<Either<Failure, List<Category>>> getAll() async {
    AppLogger.d(_tag, 'getAll()');
    try {
      final rows = await _db.categoryDao.getAll();
      AppLogger.d(_tag, 'getAll() → ${rows.length} rows');
      return Right(rows.map(CategoryMapper.fromData).toList());
    } catch (e, st) {
      AppLogger.e(_tag, 'getAll() failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> getById(String id) async {
    AppLogger.d(_tag, 'getById($id)');
    try {
      final row = await _db.categoryDao.getById(id);
      if (row == null) {
        AppLogger.w(_tag, 'getById($id) → not found');
        return Left(NotFoundFailure('Category $id not found'));
      }
      AppLogger.d(_tag, 'getById($id) → found');
      return Right(CategoryMapper.fromData(row));
    } catch (e, st) {
      AppLogger.e(_tag, 'getById($id) failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> create(Category category) async {
    AppLogger.i(_tag, 'create() name="${category.name}" id=${category.id}');
    try {
      await _db.categoryDao.insert(CategoryMapper.toCompanion(category));
      AppLogger.i(_tag, 'create() success → ${category.id}');
      return Right(category);
    } catch (e, st) {
      AppLogger.e(_tag, 'create() failed for "${category.name}"', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> update(Category category) async {
    AppLogger.i(_tag, 'update() id=${category.id} name="${category.name}"');
    try {
      await _db.categoryDao.updateCategory(CategoryMapper.toCompanion(category));
      AppLogger.i(_tag, 'update() success → ${category.id}');
      return Right(category);
    } catch (e, st) {
      AppLogger.e(_tag, 'update() failed for id=${category.id}', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    AppLogger.i(_tag, 'delete() id=$id');
    try {
      await _db.categoryDao.deleteById(id);
      AppLogger.i(_tag, 'delete() success → $id');
      return const Right(null);
    } catch (e, st) {
      AppLogger.e(_tag, 'delete() failed for id=$id', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
