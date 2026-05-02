import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

/// Represents a single financial transaction.
class Transaction extends Equatable {
  final String id;
  final double amount;
  final TransactionType type;
  final String categoryId;

  /// Which member this belongs to. Null means Family (default).
  final String? memberId;

  final String? note;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    this.memberId,
    this.note,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  Transaction copyWith({
    String? id,
    double? amount,
    TransactionType? type,
    String? categoryId,
    String? memberId,
    String? note,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Transaction(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        categoryId: categoryId ?? this.categoryId,
        memberId: memberId ?? this.memberId,
        note: note ?? this.note,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  @override
  List<Object?> get props =>
      [id, amount, type, categoryId, memberId, note, date, createdAt, updatedAt];
}
