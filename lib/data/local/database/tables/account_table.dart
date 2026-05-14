import 'package:drift/drift.dart';

class AccountTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50).unique()();
  TextColumn get accountType => text().customConstraint('CHECK (accountType IN ("cash","bank","mobile_wallet","other"))')();
  RealColumn get initialBalance => real().withDefault(const Constant(0.0))();
  IntColumn get colorInt => integer().nullable()();
  TextColumn get currency => text().withLength(min: 1, max: 4).withDefault(const Constant('৳'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}