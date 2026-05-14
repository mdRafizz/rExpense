import 'package:drift/drift.dart';

class ContributorTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();
  TextColumn get notes => text().nullable()();
  IntColumn get colorInt => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}