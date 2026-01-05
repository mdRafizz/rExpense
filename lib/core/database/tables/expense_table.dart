import 'package:drift/drift.dart';
import 'package:r_expense/core/database/tables/sub_category_table.dart';

import 'category_master_table.dart';
import 'category_table.dart';

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real()();

  IntColumn get masterId =>
      integer().references(CategoryMasters, #id)();

  IntColumn get categoryId =>
      integer().references(Categories, #id)();

  IntColumn get subCategoryId =>
      integer().references(SubCategories, #id)();

  TextColumn get note => text().nullable()();

  DateTimeColumn get expenseDate => dateTime()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}