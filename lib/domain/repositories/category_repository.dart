import '../entities/category.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';

/// Contract for category persistence operations.
abstract interface class CategoryRepository {
  /// Emits the full list of categories reactively.
  Stream<List<Category>> watchAll();

  /// Returns all categories once.
  Future<Either<Failure, List<Category>>> getAll();

  /// Returns a single category by id.
  Future<Either<Failure, Category>> getById(String id);

  /// Persists a new category.
  Future<Either<Failure, Category>> create(Category category);

  /// Updates an existing category.
  Future<Either<Failure, Category>> update(Category category);

  /// Deletes a category by id.
  Future<Either<Failure, Unit>> delete(String id);
}

/// Represents void success in Either.
typedef Unit = void;
