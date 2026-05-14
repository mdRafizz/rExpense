import 'package:drift/drift.dart';

class BeneficiaryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();
  TextColumn get relationship => text().nullable()();
  IntColumn get colorInt => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}