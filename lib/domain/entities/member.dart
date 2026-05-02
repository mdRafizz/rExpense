import 'package:equatable/equatable.dart';

/// A spending tracker profile — Personal, Wife, Child, Family, etc.
class Member extends Equatable {
  final String id;
  final String name;
  final String emoji;
  final int color;
  final bool isDefault;
  final DateTime createdAt;

  const Member({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.isDefault,
    required this.createdAt,
  });

  Member copyWith({
    String? id,
    String? name,
    String? emoji,
    int? color,
    bool? isDefault,
    DateTime? createdAt,
  }) =>
      Member(
        id: id ?? this.id,
        name: name ?? this.name,
        emoji: emoji ?? this.emoji,
        color: color ?? this.color,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  List<Object?> get props => [id, name, emoji, color, isDefault, createdAt];
}
