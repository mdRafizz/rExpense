import 'package:drift/drift.dart';
import 'categories_table.dart';

/// Drift table definition for monthly budgets.
class BudgetsTable extends Table {
  @override
  String get tableName => 'budgets';

  TextColumn get id => text()();
  TextColumn get categoryId =>
      text().references(CategoriesTable, #id)();
  RealColumn get monthlyLimit => real()();
  TextColumn get month => text()(); // 'YYYY-MM'
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
