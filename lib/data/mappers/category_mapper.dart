import '../../domain/entities/category.dart';
import '../local/database/app_database.dart';
import 'package:drift/drift.dart';

/// Maps between Drift data classes and domain entities.
class CategoryMapper {
  const CategoryMapper._();

  static Category fromData(CategoriesTableData data) => Category(
        id: data.id,
        name: data.name,
        color: data.color,
        icon: data.icon,
        isUnnecessary: data.isUnnecessary,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );

  static CategoriesTableCompanion toCompanion(Category entity) =>
      CategoriesTableCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        color: Value(entity.color),
        icon: Value(entity.icon),
        isUnnecessary: Value(entity.isUnnecessary),
        createdAt: Value(entity.createdAt),
        updatedAt: Value(entity.updatedAt),
      );
}
