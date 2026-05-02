import '../../domain/entities/budget.dart';
import '../local/database/app_database.dart';
import 'package:drift/drift.dart';

/// Maps between Drift data classes and domain Budget entities.
class BudgetMapper {
  const BudgetMapper._();

  static Budget fromData(BudgetsTableData data) => Budget(
        id: data.id,
        categoryId: data.categoryId,
        monthlyLimit: data.monthlyLimit,
        month: data.month,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );

  static BudgetsTableCompanion toCompanion(Budget entity) =>
      BudgetsTableCompanion(
        id: Value(entity.id),
        categoryId: Value(entity.categoryId),
        monthlyLimit: Value(entity.monthlyLimit),
        month: Value(entity.month),
        createdAt: Value(entity.createdAt),
        updatedAt: Value(entity.updatedAt),
      );
}
