import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../core/logger/app_logger.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  static const _tag = 'TransactionCubit';

  final TransactionRepository _repository;
  final _uuid = const Uuid();

  TransactionCubit(this._repository) : super(const TransactionInitial());

  Future<void> addTransaction({
    required double amount,
    required TransactionType type,
    required String categoryId,
    String? memberId,
    String? note,
    required DateTime date,
  }) async {
    AppLogger.i(_tag,
      'addTransaction() amount=$amount type=${type.name} '
      'cat=$categoryId member=${memberId ?? 'family'}',
    );
    emit(const TransactionLoading());

    final now = DateTime.now();
    final transaction = Transaction(
      id: _uuid.v4(),
      amount: amount,
      type: type,
      categoryId: categoryId,
      memberId: memberId,
      note: note,
      date: date,
      createdAt: now,
      updatedAt: now,
    );

    final result = await _repository.create(transaction);
    result.fold(
      (failure) {
        AppLogger.e(_tag, 'addTransaction() failed → ${failure.message}');
        emit(TransactionError(failure.message));
      },
      (t) {
        AppLogger.i(_tag, 'addTransaction() success → ${t.id}');
        emit(TransactionSuccess(t));
      },
    );
  }

  Future<void> updateTransaction(Transaction transaction) async {
    AppLogger.i(_tag, 'updateTransaction() id=${transaction.id}');
    emit(const TransactionLoading());
    final result = await _repository.update(
      transaction.copyWith(updatedAt: DateTime.now()),
    );
    result.fold(
      (failure) {
        AppLogger.e(_tag, 'updateTransaction() failed → ${failure.message}');
        emit(TransactionError(failure.message));
      },
      (t) {
        AppLogger.i(_tag, 'updateTransaction() success → ${t.id}');
        emit(TransactionSuccess(t));
      },
    );
  }

  Future<void> deleteTransaction(String id) async {
    AppLogger.i(_tag, 'deleteTransaction() id=$id');
    emit(const TransactionLoading());
    final result = await _repository.delete(id);
    result.fold(
      (failure) {
        AppLogger.e(_tag, 'deleteTransaction() failed → ${failure.message}');
        emit(TransactionError(failure.message));
      },
      (_) {
        AppLogger.i(_tag, 'deleteTransaction() success → $id');
        emit(const TransactionDeleted());
      },
    );
  }
}
