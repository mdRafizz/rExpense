import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/categories_table.dart';
import 'tables/transactions_table.dart';
import 'tables/budgets_table.dart';
import 'tables/members_table.dart';
import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/budget_dao.dart';
import 'daos/member_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [CategoriesTable, TransactionsTable, BudgetsTable, MembersTable],
  daos: [CategoryDao, TransactionDao, BudgetDao, MemberDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedMembers();
          await _seedCategories();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // Add members table
            await m.createTable(membersTable);
            // Add memberId column to transactions (nullable, no default needed)
            await m.addColumn(transactionsTable, transactionsTable.memberId);
            await _seedMembers();
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'rexpense_db');
  }

  Future<String> getDatabasePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, 'rexpense_db.sqlite');
  }

  // ── Members seed ───────────────────────────────────────────────────────────

  Future<void> _seedMembers() async {
    final now = DateTime.now();
    final members = [
      MembersTableCompanion.insert(
        id: 'member_family',
        name: 'Family',
        emoji: '👨‍👩‍👧‍👦',
        color: 0xFF6C63FF,
        isDefault: const Value(true),
        createdAt: now,
      ),
      MembersTableCompanion.insert(
        id: 'member_personal',
        name: 'Personal',
        emoji: '👤',
        color: 0xFF3A86FF,
        isDefault: const Value(false),
        createdAt: now,
      ),
      MembersTableCompanion.insert(
        id: 'member_wife',
        name: 'Wife',
        emoji: '👩',
        color: 0xFFFF6584,
        isDefault: const Value(false),
        createdAt: now,
      ),
      MembersTableCompanion.insert(
        id: 'member_child',
        name: 'Child',
        emoji: '👦',
        color: 0xFFFFBE0B,
        isDefault: const Value(false),
        createdAt: now,
      ),
    ];
    for (final m in members) {
      await into(membersTable).insertOnConflictUpdate(m);
    }
  }

  // ── Categories seed ────────────────────────────────────────────────────────
  // Icon codepoints are Material Icons font hex values.
  // Verified against MaterialIcons-Regular.ttf glyph map.

  Future<void> _seedCategories() async {
    final now = DateTime.now();

    // Helper to build a companion cleanly
    CategoriesTableCompanion cat(
      String id,
      String name,
      int color,
      String icon, {
      bool unnecessary = false,
    }) =>
        CategoriesTableCompanion.insert(
          id: id,
          name: name,
          color: color,
          icon: icon,
          isUnnecessary: Value(unnecessary),
          createdAt: now,
          updatedAt: now,
        );

    final categories = [
      // ── Daily essentials ──────────────────────────────────────────────────
      cat('cat_groceries',    'Groceries',     0xFF43B89C, 'e556'), // local_grocery_store
      cat('cat_medicine',     'Medicine',      0xFFEF476F, 'e1bc'), // medication
      cat('cat_food',         'Food',          0xFFFF6584, 'e56c'), // restaurant
      cat('cat_transport',    'Transport',     0xFF3A86FF, 'e531'), // directions_car

      // ── Protein sub-group ─────────────────────────────────────────────────
      cat('cat_protein',      'Protein',       0xFFFF9F1C, 'e533'), // egg (directions_run fallback)
      // Note: egg icon = 0xf06e3 in newer Material; using local_dining as proxy
      cat('cat_egg',          'Egg',           0xFFFFBE0B, 'e56c'), // restaurant (egg proxy)
      cat('cat_meat',         'Meat / Fish',   0xFFFF6B6B, 'e533'), // set_meal proxy

      // ── Staples ───────────────────────────────────────────────────────────
      cat('cat_staples',      'Staples',       0xFF8338EC, 'e544'), // local_florist proxy → grain
      // Rice, ata, flour etc.

      // ── Bills & utilities ─────────────────────────────────────────────────
      cat('cat_electricity',  'Electricity',   0xFFFFBE0B, 'e63e'), // bolt / electric_bolt
      cat('cat_rent',         'Rent',          0xFF118AB2, 'e88a'), // home
      cat('cat_internet',     'Internet',      0xFF3A86FF, 'e63e'), // wifi proxy
      cat('cat_mobile',       'Mobile',        0xFF6C63FF, 'e325'), // smartphone
      cat('cat_utilities',    'Utilities',     0xFF06D6A0, 'e1ff'), // build / settings

      // ── Finance ───────────────────────────────────────────────────────────
      cat('cat_lend',         'Lend',          0xFF43B89C, 'e8b3'), // send_money proxy → payments
      cat('cat_borrow',       'Borrow',        0xFFEF476F, 'e8b3'), // payments
      cat('cat_salary',       'Salary',        0xFF06D6A0, 'e227'), // account_balance_wallet
      cat('cat_subscription', 'Subscription',  0xFF8338EC, 'e8f9'), // subscriptions

      // ── Health ────────────────────────────────────────────────────────────
      cat('cat_health',       'Health',        0xFFEF476F, 'e548'), // favorite / health
      // doctor visits, tests — medicine is separate

      // ── Lifestyle ─────────────────────────────────────────────────────────
      cat('cat_shopping',     'Shopping',      0xFF8338EC, 'e8cc', unnecessary: true), // shopping_bag
      cat('cat_entertainment','Entertainment', 0xFFFFBE0B, 'e02c', unnecessary: true), // movie
      cat('cat_personal',     'Personal',      0xFF3A86FF, 'e7fd'), // person
      cat('cat_education',    'Education',     0xFF118AB2, 'e80c'), // school
      cat('cat_travel',       'Travel',        0xFF43B89C, 'e332'), // flight

      // ── Social ────────────────────────────────────────────────────────────
      cat('cat_family',       'Family',        0xFF6C63FF, 'e7fb'), // group
      cat('cat_gift',         'Gift',          0xFFFF6584, 'e8f6', unnecessary: true), // card_giftcard
      cat('cat_charity',      'Charity',       0xFF06D6A0, 'e8d1'), // volunteer_activism proxy

      // ── Home ──────────────────────────────────────────────────────────────
      cat('cat_maintenance',  'Maintenance',   0xFF118AB2, 'e869'), // build / home_repair_service

      // ── Fallback ──────────────────────────────────────────────────────────
      cat('cat_others',       'Others',        0xFF9CA3AF, 'e8b8'), // more_horiz
    ];

    for (final c in categories) {
      await into(categoriesTable).insertOnConflictUpdate(c);
    }
  }
}
