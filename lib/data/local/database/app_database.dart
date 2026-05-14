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
        CategoryTableCompanion.insert(
          name: '💰 Salary',
          type: 'income',
          colorInt: const Value(0xFF34C759), // iOS Green
        ),
        CategoryTableCompanion.insert(
          name: '🛒 Grocery',
          type: 'expense',
          colorInt: const Value(0xFFFF9F0A), // iOS Orange
        ),
        CategoryTableCompanion.insert(
          name: '🏠 Rent',
          type: 'expense',
          colorInt: const Value(0xFF5E5CE6), // iOS Indigo
        ),
        CategoryTableCompanion.insert(
          name: '⚡ Utilities',
          type: 'expense',
          colorInt: const Value(0xFFFFD60A), // iOS Yellow
        ),
      ]);

      b.insertAll(contributorTable, [
        ContributorTableCompanion.insert(
          name: '👤 Self',
          notes: const Value('Personal income'),
          colorInt: const Value(0xFF0A84FF), // iOS Blue
        ),
        ContributorTableCompanion.insert(
          name: '💑 Spouse',
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
