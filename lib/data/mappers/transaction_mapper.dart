import '../../domain/entities/transaction.dart';
import '../local/database/app_database.dart';
import 'package:drift/drift.dart';

/// Maps between Drift data classes and domain Transaction entities.
class TransactionMapper {
  const TransactionMapper._();

  static Transaction fromData(TransactionsTableData data) => Transaction(
        id: data.id,
        amount: data.amount,
        type: data.type == 'income'
            ? TransactionType.income
            : TransactionType.expense,
        categoryId: data.categoryId,
        note: data.note,
        date: data.date,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );

  static TransactionsTableCompanion toCompanion(Transaction entity) =>
      TransactionsTableCompanion(
        id: Value(entity.id),
        amount: Value(entity.amount),
        type: Value(entity.type == TransactionType.income ? 'income' : 'expense'),
        categoryId: Value(entity.categoryId),
        note: Value(entity.note),
        date: Value(entity.date),
        createdAt: Value(entity.createdAt),
        updatedAt: Value(entity.updatedAt),
      );
}
