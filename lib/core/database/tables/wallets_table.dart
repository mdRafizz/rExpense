import 'package:drift/drift.dart';

class Wallets extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get type => text()();
  // cash, bank, mobile, credit

  TextColumn get accountNumber => text().nullable()();

  DateTimeColumn get openingDate => dateTime().nullable()();

  DateTimeColumn get closingDate => dateTime().nullable()();

  RealColumn get openingBalance => real().withDefault(const Constant(0))();

  RealColumn get currentBalance => real().withDefault(const Constant(0))();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
