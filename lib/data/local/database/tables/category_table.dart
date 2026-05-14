import 'package:drift/drift.dart';

class CategoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 50)();

  TextColumn get type =>
      text().customConstraint('CHECK (type IN ("income","expense"))')();

  TextColumn get note => text().nullable()();

  IntColumn get colorInt => integer().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
