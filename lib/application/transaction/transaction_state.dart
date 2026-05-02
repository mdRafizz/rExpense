part of 'transaction_cubit.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

final class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

final class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

final class TransactionSuccess extends TransactionState {
  final Transaction transaction;
  const TransactionSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

final class TransactionDeleted extends TransactionState {
  const TransactionDeleted();
}

final class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
