import 'package:equatable/equatable.dart';

enum VarianceDirection { up, down, neutral }

/// Period-over-period variance for a single category.
class VarianceInsight extends Equatable {
  final String categoryId;
  final String categoryName;
  final double currentAmount;
  final double previousAmount;
  final double variancePercent; // positive = spent more, negative = spent less
  final VarianceDirection direction;

  const VarianceInsight({
    required this.categoryId,
    required this.categoryName,
    required this.currentAmount,
    required this.previousAmount,
    required this.variancePercent,
    required this.direction,
  });

  /// Human-readable insight message.
  String get message {
    final abs = variancePercent.abs().toStringAsFixed(1);
    return switch (direction) {
      VarianceDirection.up =>
        'You spent $abs% more on $categoryName than last period',
      VarianceDirection.down =>
        'You spent $abs% less on $categoryName than last period',
      VarianceDirection.neutral =>
        'Your $categoryName spending is on par with last period',
    };
  }

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        currentAmount,
        previousAmount,
        variancePercent,
        direction,
      ];
}
