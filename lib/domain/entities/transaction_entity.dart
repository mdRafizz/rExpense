import 'package:equatable/equatable.dart';

enum TransactionType { income, expense }

class TransactionEntity extends Equatable {
  final int? id;
  final double amount;
  final DateTime dateTime;
  final String? notes;
  final TransactionType transactionType;
  final int categoryId;
  final int? contributorId;
  final int? beneficiaryId;
  final int accountId;

  const TransactionEntity(
      {this.id,
      required this.amount,
      required this.dateTime,
      this.notes,
      required this.transactionType,
      required this.categoryId,
      this.contributorId,
      this.beneficiaryId,
      required this.accountId});

  // Helper to check if income or expense
  bool get isIncome => transactionType == TransactionType.income;

  bool get isExpense => transactionType == TransactionType.expense;

  @override
  List<Object?> get props => [
        id,
        amount,
        dateTime,
        notes,
        transactionType,
        categoryId,
        contributorId,
        beneficiaryId,
        accountId
      ];
}
