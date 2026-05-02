import 'package:drift/drift.dart';

/// Tracks who a transaction belongs to: Personal, Wife, Child, Family.
class MembersTable extends Table {
  @override
  String get tableName => 'members';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get emoji => text()(); // e.g. '👤', '👩', '👦', '👨‍👩‍👧‍👦'
  IntColumn get color => integer()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
