import 'package:equatable/equatable.dart';

/// Represents a user-defined transaction category.
class Category extends Equatable {
  final String id;
  final String name;
  final int color; // ARGB int
  final String icon; // Material icon codepoint as hex string e.g. 'e318'
  final bool isUnnecessary; // Marks category for spending-leak analysis
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    this.isUnnecessary = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Category copyWith({
    String? id,
    String? name,
    int? color,
    String? icon,
    bool? isUnnecessary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isUnnecessary: isUnnecessary ?? this.isUnnecessary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, color, icon, isUnnecessary, createdAt, updatedAt];
}
