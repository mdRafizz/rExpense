import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rexpense/data/local/database/tables/account_table.dart';
import 'package:rexpense/data/local/database/tables/beneficiary_table.dart';
import 'package:rexpense/data/local/database/tables/category_table.dart';
import 'package:rexpense/data/local/database/tables/contributor_table.dart';
import 'package:rexpense/data/local/database/tables/transaction_table.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'converters.dart';
import 'daos/account_dao.dart';
import 'daos/beneficiary_dao.dart';
import 'daos/category_dao.dart';
import 'daos/contributor_dao.dart';
import 'daos/transaction_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  CategoryTable,
  ContributorTable,
  BeneficiaryTable,
  AccountTable,
  TransactionTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // DAOs
  late final CategoryDao categoryDao = CategoryDao(this);
  late final ContributorDao contributorDao = ContributorDao(this);
  late final BeneficiaryDao beneficiaryDao = BeneficiaryDao(this);
  late final AccountDao accountDao = AccountDao(this);
  late final TransactionDao transactionDao = TransactionDao(this);

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (migrator) async {
          await migrator.createAll();
          await _insertDefaultData();
        },
        onUpgrade: (migrator, from, to) async {},
      );

  Future<void> _insertDefaultData() async {
    await batch((b) {
      b.insertAll(categoryTable, [
        // ================= INCOME =================

        CategoryTableCompanion.insert(
          name: '💰 Salary',
          type: 'income',
          note: const Value(
            'Monthly salary, office payment, freelance income',
          ),
          colorInt: const Value(0xFF34C759), // iOS Green
        ),

        CategoryTableCompanion.insert(
          name: '🎁 Gift',
          type: 'income',
          note: const Value(
            'Gift money, bonus, rewards, eid salami',
          ),
          colorInt: const Value(0xFF30B0C7),
        ),

        CategoryTableCompanion.insert(
          name: '📈 Business',
          type: 'income',
          note: const Value(
            'Business profit, shop income, side income',
          ),
          colorInt: const Value(0xFF32ADE6),
        ),

        // ================= EXPENSE =================

        CategoryTableCompanion.insert(
          name: '🛒 Grocery',
          type: 'expense',
          note: const Value(
            'Rice, oil, vegetables, daily household shopping',
          ),
          colorInt: const Value(0xFFFF9F0A), // iOS Orange
        ),

        CategoryTableCompanion.insert(
          name: '🥚 Egg',
          type: 'expense',
          note: const Value(
            'Egg purchase for home cooking and meals',
          ),
          colorInt: const Value(0xFFFFCC00),
        ),

        CategoryTableCompanion.insert(
          name: '🍖 Meat',
          type: 'expense',
          note: const Value(
            'Chicken, beef, mutton, fish purchase',
          ),
          colorInt: const Value(0xFFFF3B30),
        ),

        CategoryTableCompanion.insert(
          name: '🏠 Rent',
          type: 'expense',
          note: const Value(
            'House rent, apartment rent, hostel payment',
          ),
          colorInt: const Value(0xFF5E5CE6), // iOS Indigo
        ),

        CategoryTableCompanion.insert(
          name: '⚡ Utilities',
          type: 'expense',
          note: const Value(
            'Electricity, water, gas, internet, mobile bill',
          ),
          colorInt: const Value(0xFFFFD60A), // iOS Yellow
        ),

        CategoryTableCompanion.insert(
          name: '🚌 Transport',
          type: 'expense',
          note: const Value(
            'Bus fare, rickshaw, CNG, fuel, Uber',
          ),
          colorInt: const Value(0xFF64D2FF),
        ),

        CategoryTableCompanion.insert(
          name: '✈️ Travel',
          type: 'expense',
          note: const Value(
            'Tour, hotel, tickets, vacation expenses',
          ),
          colorInt: const Value(0xFF0A84FF),
        ),

        CategoryTableCompanion.insert(
          name: '📚 Education',
          type: 'expense',
          note: const Value(
            'Books, courses, tuition, exam fees',
          ),
          colorInt: const Value(0xFFBF5AF2),
        ),

        CategoryTableCompanion.insert(
          name: '💊 Medical',
          type: 'expense',
          note: const Value(
            'Medicine, doctor fees, hospital expenses',
          ),
          colorInt: const Value(0xFFFF375F),
        ),

        CategoryTableCompanion.insert(
          name: '🍽️ Restaurant',
          type: 'expense',
          note: const Value(
            'Dining out, fast food, cafe expenses',
          ),
          colorInt: const Value(0xFFFF9500),
        ),

        CategoryTableCompanion.insert(
          name: '🎉 Entertainment',
          type: 'expense',
          note: const Value(
            'Movies, games, subscriptions, fun activities',
          ),
          colorInt: const Value(0xFFAF52DE),
        ),

        CategoryTableCompanion.insert(
          name: '🤲 Sadaqah',
          type: 'expense',
          note: const Value(
            'Charity, donations, helping needy people',
          ),
          colorInt: const Value(0xFF30D158),
        ),

        /*CategoryTableCompanion.insert(
          name: '👨‍👩‍👧 Family',
          type: 'expense',
          note: const Value(
            'Parents, spouse, children, family support',
          ),
          colorInt: const Value(0xFFFF6482),
        ),*/
      ]);

      b.insertAll(contributorTable, [
        ContributorTableCompanion.insert(
          name: '👤 Self',
          notes: const Value('Personal income'),
          colorInt: const Value(0xFF0A84FF), // iOS Blue
        ),
        ContributorTableCompanion.insert(
          name: '💖 Spouse',
          notes: const Value('Partner income'),
          colorInt: const Value(0xFFFF375F), // iOS Pink
        ),
      ]);

      b.insertAll(beneficiaryTable, [
        BeneficiaryTableCompanion.insert(
          name: '👤 Self',
          relationship: const Value('Personal'),
          colorInt: const Value(0xFF30D158), // iOS Mint
        ),
        BeneficiaryTableCompanion.insert(
          name: '👨‍👩‍👧‍👦 Family',
          relationship: const Value('Household'),
          colorInt: const Value(0xFFFF6B00), // iOS Deep Orange
        ),
        BeneficiaryTableCompanion.insert(
          name: '👥 Friends',
          relationship: const Value('Social'),
          colorInt: const Value(0xFFBF5AF2), // iOS Purple
        ),
        BeneficiaryTableCompanion.insert(
          name: '💑 Spouse',
          relationship: const Value('Partner'),
          colorInt: const Value(0xFFFF2D55), // iOS Rose
        ),
      ]);

      b.insertAll(accountTable, [
        AccountTableCompanion.insert(
          name: '💵 Cash',
          accountType: 'cash',
          initialBalance: const Value(0.0),
          colorInt: const Value(0xFF32ADE6), // iOS Teal
        ),
        AccountTableCompanion.insert(
          name: '🏦 Standard Chartered',
          accountType: 'bank',
          initialBalance: const Value(0.0),
          colorInt: const Value(0xFFFF3B30), // iOS Red
        ),
        AccountTableCompanion.insert(
          name: '🏦 Sonali Bank',
          accountType: 'bank',
          initialBalance: const Value(0.0),
          colorInt: const Value(0xFF34C759), // iOS Emerald
        ),
      ]);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbDir.path, 'finance_tracker.db');

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    return NativeDatabase.createInBackground(File(dbPath));
  });
}
