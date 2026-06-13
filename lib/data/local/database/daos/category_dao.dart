import 'package:drift/drift.dart';
import '../app_database.dart';

class CategoryDao {
  final AppDatabase _db;

  const CategoryDao(this._db);

  // Get all categories
  Stream<List<CategoryTableData>> watchAllCategories() {
    return _db.select(_db.categoryTable).watch();
  }

  Future<List<CategoryTableData>> getAllCategories() {
    return _db.select(_db.categoryTable).get();
  }

  // Get categories by type
  Stream<List<CategoryTableData>> watchCategoriesByType(String type) {
    return (_db.select(_db.categoryTable)
          ..where((t) => t.type.equals(type) & t.isActive.equals(true)))
        .watch();
  }

  Future<List<CategoryTableData>> getCategoriesByType(String type) {
    return (_db.select(_db.categoryTable)
          ..where((t) => t.type.equals(type) & t.isActive.equals(true)))
        .get();
  }

  // Get category by id
  Future<CategoryTableData?> getCategoryById(int id) {
    return (_db.select(_db.categoryTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Insert category
  Future<int> insertCategory({
    required String name,
    required String type,
    String? note,
    int? colorInt,
  }) {
    return _db.into(_db.categoryTable).insert(
          CategoryTableCompanion.insert(
            name: name,
            type: type,
            note: Value(note),
            colorInt: Value(colorInt),
          ),
        );
  }

  // Update category
  Future<bool> updateCategory({
    required int id,
    String? name,
    String? type,
    String? note,
    int? colorInt,
    bool? isActive,
  }) {
    return _db.update(_db.categoryTable).replace(
          CategoryTableData(
            id: id,
            name: name ?? '',
            type: type ?? 'expense',
            note: note,
            colorInt: colorInt,
            isActive: isActive ?? true,
          ),
        );
  }

  // Delete category (soft delete)
  Future<int> deleteCategory(int id) {
    return (_db.update(_db.categoryTable)..where((t) => t.id.equals(id)))
        .write(const CategoryTableCompanion(isActive: Value(false)));
  }

  // Hard delete category
  Future<int> hardDeleteCategory(int id) {
    return (_db.delete(_db.categoryTable)..where((t) => t.id.equals(id))).go();
  }
}
