import '../entities/category.dart';
import '../repositories/category_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import 'package:uuid/uuid.dart';

/// Use-cases for category CRUD operations.
class ManageCategories {
  final CategoryRepository _repository;
  final _uuid = const Uuid();

  ManageCategories(this._repository);

  Stream<List<Category>> watchAll() => _repository.watchAll();

  Future<Either<Failure, List<Category>>> getAll() => _repository.getAll();

  Future<Either<Failure, Category>> create({
    required String name,
    required int color,
    required String icon,
    bool isUnnecessary = false,
  }) {
    if (name.trim().isEmpty) {
      return Future.value(
        Left(const ValidationFailure('Category name cannot be empty')),
      );
    }
    final now = DateTime.now();
    final category = Category(
      id: _uuid.v4(),
      name: name.trim(),
      color: color,
      icon: icon,
      isUnnecessary: isUnnecessary,
      createdAt: now,
      updatedAt: now,
    );
    return _repository.create(category);
  }

  Future<Either<Failure, Category>> update(Category category) {
    if (category.name.trim().isEmpty) {
      return Future.value(
        Left(const ValidationFailure('Category name cannot be empty')),
      );
    }
    return _repository.update(
      category.copyWith(updatedAt: DateTime.now()),
    );
  }

  Future<Either<Failure, void>> delete(String id) =>
      _repository.delete(id);
}
