import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';

import '../local/database/app_database.dart';
import '../mappers/category_mapper.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase _db;

  const CategoryRepositoryImpl(this._db);

  @override
  Stream<List<Category>> watchAll() =>
      _db.categoryDao.watchAll().map(
        (rows) => rows.map(CategoryMapper.fromData).toList(),
      );

  @override
  Future<Either<Failure, List<Category>>> getAll() async {
    try {
      final rows = await _db.categoryDao.getAll();
      return Right(rows.map(CategoryMapper.fromData).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> getById(String id) async {
    try {
      final row = await _db.categoryDao.getById(id);
      if (row == null) return Left(NotFoundFailure('Category $id not found'));
      return Right(CategoryMapper.fromData(row));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> create(Category category) async {
    try {
      await _db.categoryDao.insert(CategoryMapper.toCompanion(category));
      return Right(category);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Category>> update(Category category) async {
    try {
      await _db.categoryDao.updateCategory(CategoryMapper.toCompanion(category));
      return Right(category);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await _db.categoryDao.deleteById(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
