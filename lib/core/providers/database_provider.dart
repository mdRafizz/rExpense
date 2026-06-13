import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/database/app_database.dart';
import '../../data/local/database/daos/account_dao.dart';
import '../../data/local/database/daos/beneficiary_dao.dart';
import '../../data/local/database/daos/category_dao.dart';
import '../../data/local/database/daos/contributor_dao.dart';
import '../../data/local/database/daos/transaction_dao.dart';

part 'database_provider.g.dart';

@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
TransactionDao transactionDao(TransactionDaoRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.transactionDao;
}

@riverpod
CategoryDao categoryDao(CategoryDaoRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.categoryDao;
}

@riverpod
ContributorDao contributorDao(ContributorDaoRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.contributorDao;
}

@riverpod
BeneficiaryDao beneficiaryDao(BeneficiaryDaoRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.beneficiaryDao;
}

@riverpod
AccountDao accountDao(AccountDaoRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.accountDao;
}
