import 'package:drift/drift.dart';
import 'package:r_expense/core/database/tables/category_master_table.dart';

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get masterId => integer().references(CategoryMasters, #id)();

  TextColumn get name => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
