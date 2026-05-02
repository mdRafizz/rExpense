import 'package:drift/drift.dart';
import 'categories_table.dart';
import 'members_table.dart';

/// Drift table definition for transactions.
class TransactionsTable extends Table {
  @override
  String get tableName => 'transactions';

  TextColumn get id => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // 'income' | 'expense'
  TextColumn get categoryId => text().references(CategoriesTable, #id)();

  /// Which member this transaction belongs to.
  /// Nullable for backwards-compat; treated as 'family' when null.
  TextColumn get memberId =>
      text().nullable().references(MembersTable, #id)();

  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
