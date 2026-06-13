import 'package:drift/drift.dart';
import '../app_database.dart';

class AccountDao {
  final AppDatabase _db;

  const AccountDao(this._db);

  // Get all accounts
  Stream<List<AccountTableData>> watchAllAccounts() {
    return (_db.select(_db.accountTable)
          ..where((t) => t.isActive.equals(true)))
        .watch();
  }

  Future<List<AccountTableData>> getAllAccounts() {
    return (_db.select(_db.accountTable)
          ..where((t) => t.isActive.equals(true)))
        .get();
  }

  // Get account by id
  Future<AccountTableData?> getAccountById(int id) {
    return (_db.select(_db.accountTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Insert account
  Future<int> insertAccount({
    required String name,
    required String accountType,
    double initialBalance = 0.0,
    int? colorInt,
    String currency = '৳',
  }) {
    return _db.into(_db.accountTable).insert(
          AccountTableCompanion.insert(
            name: name,
            accountType: accountType,
            initialBalance: Value(initialBalance),
            colorInt: Value(colorInt),
            currency: Value(currency),
          ),
        );
  }

  // Update account
  Future<bool> updateAccount({
    required int id,
    String? name,
    String? accountType,
    double? initialBalance,
    int? colorInt,
    String? currency,
    bool? isActive,
  }) {
    return _db.update(_db.accountTable).replace(
          AccountTableData(
            id: id,
            name: name ?? '',
            accountType: accountType ?? 'cash',
            initialBalance: initialBalance ?? 0.0,
            colorInt: colorInt,
            currency: currency ?? '৳',
            isActive: isActive ?? true,
          ),
        );
  }

  // Delete account (soft delete)
  Future<int> deleteAccount(int id) {
    return (_db.update(_db.accountTable)..where((t) => t.id.equals(id)))
        .write(const AccountTableCompanion(isActive: Value(false)));
  }

  // Hard delete account
  Future<int> hardDeleteAccount(int id) {
    return (_db.delete(_db.accountTable)..where((t) => t.id.equals(id))).go();
  }

  // Get account balance
  Future<double> getAccountBalance(int accountId) async {
    final account = await getAccountById(accountId);
    if (account == null) return 0.0;

    final transactions = await (_db.select(_db.transactionTable)
          ..where((t) => t.accountId.equals(accountId)))
        .get();

    final totalIncome = transactions
        .where((t) => t.transactionType == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpense = transactions
        .where((t) => t.transactionType == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    return account.initialBalance + totalIncome - totalExpense;
  }
}
