import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/budgets_table.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [BudgetsTable])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  /// Reactively emits budgets for a given month.
  Stream<List<BudgetsTableData>> watchByMonth(String month) =>
      (select(budgetsTable)..where((t) => t.month.equals(month))).watch();

  /// Returns budgets for a given month once.
  Future<List<BudgetsTableData>> getByMonth(String month) =>
      (select(budgetsTable)..where((t) => t.month.equals(month))).get();

  /// Returns the budget for a specific category and month.
  Future<BudgetsTableData?> getByCategoryAndMonth(
    String categoryId,
    String month,
  ) =>
      (select(budgetsTable)
            ..where((t) =>
                t.categoryId.equals(categoryId) & t.month.equals(month)))
          .getSingleOrNull();

  /// Inserts a new budget.
  Future<void> insert(BudgetsTableCompanion companion) =>
      into(budgetsTable).insert(companion);

  /// Updates an existing budget.
  Future<bool> updateBudget(BudgetsTableCompanion companion) =>
      update(budgetsTable).replace(companion);

  /// Deletes a budget by id.
  Future<int> deleteById(String id) =>
      (delete(budgetsTable)..where((t) => t.id.equals(id))).go();
}
