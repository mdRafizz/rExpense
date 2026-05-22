import 'package:drift/drift.dart';
import 'package:rexpense/data/local/database/tables/account_table.dart';
import 'package:rexpense/data/local/database/tables/beneficiary_table.dart';
import 'package:rexpense/data/local/database/tables/category_table.dart';
import 'package:rexpense/data/local/database/tables/contributor_table.dart';

@TableIndex(name: 'idx_transactions_date', columns: {#transactionDate})
@TableIndex(name: 'idx_transactions_category', columns: {#categoryId})
@TableIndex(name: 'idx_transactions_beneficiary', columns: {#beneficiaryId})
@TableIndex(
  name: 'idx_transactions_type_date',
  columns: {#transactionType, #transactionDate},
)
class TransactionTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get amount => real().withDefault(const Constant(0.0))();

  DateTimeColumn get transactionDate => dateTime()();

  TextColumn get notes => text().nullable()();

  TextColumn get transactionType => text().customConstraint(
        'NOT NULL CHECK (transactionType IN ("income","expense"))',
      )();

  IntColumn get categoryId => integer().references(CategoryTable, #id)();

  IntColumn get contributorId =>
      integer().nullable().references(ContributorTable, #id)();

  IntColumn get beneficiaryId =>
      integer().nullable().references(BeneficiaryTable, #id)();

  IntColumn get accountId => integer().references(AccountTable, #id)();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
