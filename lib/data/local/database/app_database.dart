import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/categories_table.dart';
import 'tables/transactions_table.dart';
import 'tables/budgets_table.dart';
import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/budget_dao.dart';

part 'app_database.g.dart';

/// The single Drift database instance for the application.
@DriftDatabase(
  tables: [CategoriesTable, TransactionsTable, BudgetsTable],
  daos: [CategoryDao, TransactionDao, BudgetDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedDefaultCategories();
        },
        onUpgrade: (m, from, to) async {
          // Future migrations go here
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'rexpense_db');
  }

  /// Returns the path to the underlying SQLite file for backup purposes.
  Future<String> getDatabasePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, 'rexpense_db.sqlite');
  }

  Future<void> _seedDefaultCategories() async {
    final now = DateTime.now();
    final defaults = [
      CategoriesTableCompanion.insert(
        id: 'cat_food',
        name: 'Food & Dining',
        color: 0xFFFF6584,
        icon: 'e56c', // restaurant
        isUnnecessary: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_transport',
        name: 'Transport',
        color: 0xFF3A86FF,
        icon: 'e531', // directions_car
        isUnnecessary: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_shopping',
        name: 'Shopping',
        color: 0xFF8338EC,
        icon: 'e8cc', // shopping_bag
        isUnnecessary: const Value(true),
        createdAt: now,
        updatedAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_entertainment',
        name: 'Entertainment',
        color: 0xFFFFBE0B,
        icon: 'e02c', // movie
        isUnnecessary: const Value(true),
        createdAt: now,
        updatedAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_health',
        name: 'Health',
        color: 0xFF43B89C,
        icon: 'e548', // favorite
        isUnnecessary: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_coffee',
        name: 'Coffee',
        color: 0xFFFF9F1C,
        icon: 'e541', // local_cafe
        isUnnecessary: const Value(true),
        createdAt: now,
        updatedAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_salary',
        name: 'Salary',
        color: 0xFF06D6A0,
        icon: 'e227', // account_balance_wallet
        isUnnecessary: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
      CategoriesTableCompanion.insert(
        id: 'cat_utilities',
        name: 'Utilities',
        color: 0xFF118AB2,
        icon: 'e1ff', // home
        isUnnecessary: const Value(false),
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final cat in defaults) {
      await into(categoriesTable).insertOnConflictUpdate(cat);
    }
  }
}
