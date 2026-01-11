import 'package:drift/drift.dart';

import 'income_source.dart';

class Income extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real()();

  IntColumn get sourceId =>
      integer().references(IncomeSources, #id)();

  DateTimeColumn get incomeDate => dateTime()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
