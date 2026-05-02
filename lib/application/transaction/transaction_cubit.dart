import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';


part 'transaction_state.dart';

/// Manages CRUD operations for transactions.
class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _repository;
  final _uuid = const Uuid();

  TransactionCubit(this._repository) : super(const TransactionInitial());

  Future<void> addTransaction({
    required double amount,
    required TransactionType type,
    required String categoryId,
    String? note,
    required DateTime date,
  }) async {
    emit(const TransactionLoading());
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

    final result = await _repository.create(transaction);
    result.fold(
      (failure) => emit(TransactionError(failure.message)),
      (t) => emit(TransactionSuccess(t)),
    );
  }

  Future<void> updateTransaction(Transaction transaction) async {
    emit(const TransactionLoading());
    final result = await _repository.update(
      transaction.copyWith(updatedAt: DateTime.now()),
    );
    result.fold(
      (failure) => emit(TransactionError(failure.message)),
      (t) => emit(TransactionSuccess(t)),
    );
  }

  Future<void> deleteTransaction(String id) async {
    emit(const TransactionLoading());
    final result = await _repository.delete(id);
    result.fold(
      (failure) => emit(TransactionError(failure.message)),
      (_) => emit(const TransactionDeleted()),
    );
  }
}
