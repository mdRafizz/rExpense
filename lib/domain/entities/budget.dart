import 'package:equatable/equatable.dart';

/// A monthly spending limit for a specific category.
class Budget extends Equatable {
  final String id;
  final String categoryId;
  final double monthlyLimit;
  final String month; // 'YYYY-MM'
  final DateTime createdAt;
  final DateTime updatedAt;

  const Budget({
    required this.id,
    required this.categoryId,
    required this.monthlyLimit,
    required this.month,
    required this.createdAt,
    required this.updatedAt,
  });

  Budget copyWith({
    String? id,
    String? categoryId,
    double? monthlyLimit,
    String? month,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      month: month ?? this.month,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, categoryId, monthlyLimit, month, createdAt, updatedAt];
}
