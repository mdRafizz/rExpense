import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'transaction_entity.dart';


class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final TransactionType type;
  final int colorValue;
  final bool isActive;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.colorValue,
    this.isActive = true,
  });

  // Helper getter to easily get a Flutter Color object in your UI
  Color get color => Color(colorValue);

  @override
  List<Object?> get props => [id, name, type, colorValue, isActive];
}