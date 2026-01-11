import 'package:drift/drift.dart';

class IncomeSources extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
