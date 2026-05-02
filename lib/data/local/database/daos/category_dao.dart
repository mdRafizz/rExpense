import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [CategoriesTable])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  /// Reactively emits all categories ordered by name.
  Stream<List<CategoriesTableData>> watchAll() =>
      (select(categoriesTable)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  /// Returns all categories once.
  Future<List<CategoriesTableData>> getAll() =>
      (select(categoriesTable)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  /// Returns a single category by id.
  Future<CategoriesTableData?> getById(String id) =>
      (select(categoriesTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Inserts a new category.
  Future<void> insert(CategoriesTableCompanion companion) =>
      into(categoriesTable).insert(companion);

  /// Updates an existing category.
  Future<bool> updateCategory(CategoriesTableCompanion companion) =>
      update(categoriesTable).replace(companion);

  /// Deletes a category by id.
  Future<int> deleteById(String id) =>
      (delete(categoriesTable)..where((t) => t.id.equals(id))).go();
}
