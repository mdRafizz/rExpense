import 'package:uuid/uuid.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';

/// Use-cases for transaction CRUD operations.
class ManageTransactions {
  final TransactionRepository _repository;
  final _uuid = const Uuid();

  ManageTransactions(this._repository);

  Stream<List<Transaction>> watchByDateRange(DateTime start, DateTime end) =>
      _repository.watchByDateRange(start, end);

  Future<Either<Failure, Transaction>> create({
    required double amount,
    required TransactionType type,
    required String categoryId,
    String? note,
    required DateTime date,
  }) {
    if (amount <= 0) {
      return Future.value(
        Left(const ValidationFailure('Amount must be positive')),
      );
    }
    if (categoryId.isEmpty) {
      return Future.value(
        Left(const ValidationFailure('Category is required')),
      );
    }
    final now = DateTime.now();
    final transaction = Transaction(
      id: _uuid.v4(),
      amount: amount,
      type: type,
      categoryId: categoryId,
      note: note,
      date: date,
      createdAt: now,
      updatedAt: now,
    );
    return _repository.create(transaction);
  }

  Future<Either<Failure, Transaction>> update(Transaction transaction) {
    if (transaction.amount <= 0) {
      return Future.value(
        Left(const ValidationFailure('Amount must be positive')),
      );
    }
    return _repository.update(
      transaction.copyWith(updatedAt: DateTime.now()),
    );
  }

  Future<Either<Failure, void>> delete(String id) =>
      _repository.delete(id);
}
