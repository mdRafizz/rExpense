import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  //create transaction
  Future<void> addTransaction(TransactionEntity transaction);

  //read
  Future<List<TransactionEntity>> getAllTransactions();

  Future<List<TransactionEntity>> getTransactionsByDateRange(
      DateTime start, DateTime end);

  Future<double> getNetBalance({
    DateTime? startDate,
    DateTime? endDate,
    int? accountId,
  });

  Future<Map<String, double>> getExpensesByCategory(DateTime month);

  Future<Map<String, double>> getExpensesByBeneficiary({
    DateTime? startDate,
    DateTime? endDate,
  });

  // Update
  Future<void> updateTransaction(TransactionEntity transaction);

  // Delete
  Future<void> deleteTransaction(int id);
}
