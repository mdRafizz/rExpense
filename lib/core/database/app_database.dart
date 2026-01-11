import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:r_expense/core/database/tables/income_source.dart';
import 'package:r_expense/core/database/tables/income_table.dart';

import 'tables/category_master_table.dart';
import 'tables/category_table.dart';
import 'tables/sub_category_table.dart';
import 'tables/expense_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CategoryMasters,
    Categories,
    SubCategories,
    Expenses,
    Income,
    IncomeSources,
  ],
)

class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'expense_tracker.db'));
    return NativeDatabase(file);
  });
}