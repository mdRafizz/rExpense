import 'package:drift/drift.dart';
import 'package:r_expense/core/database/tables/category_table.dart';

class SubCategories extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get categoryId => integer().references(Categories, #id)();

  TextColumn get name => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
