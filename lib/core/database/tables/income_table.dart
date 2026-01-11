import 'package:drift/drift.dart';
import 'package:r_expense/core/database/tables/wallets_table.dart';

import 'income_source.dart';

class Income extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real()();

  IntColumn get sourceId => integer().references(IncomeSources, #id)();

  IntColumn get walletId => integer().references(Wallets, #id)();

  DateTimeColumn get incomeDate => dateTime()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
