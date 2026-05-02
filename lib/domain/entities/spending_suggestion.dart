import 'package:equatable/equatable.dart';

enum SuggestionSeverity { low, medium, high }

/// A spending-leak suggestion for an 'unnecessary' category.
class SpendingSuggestion extends Equatable {
  final String categoryId;
  final String categoryName;
  final double spent;
  final double threshold;
  final double overagePercent;
  final SuggestionSeverity severity;

  const SpendingSuggestion({
    required this.categoryId,
    required this.categoryName,
    required this.spent,
    required this.threshold,
    required this.overagePercent,
    required this.severity,
  });

  /// Human-readable suggestion message.
  String get message {
    final pct = overagePercent.toStringAsFixed(1);
    return switch (severity) {
      SuggestionSeverity.high =>
        '⚠️ You\'ve exceeded your $categoryName budget by $pct%. Consider cutting back.',
      SuggestionSeverity.medium =>
        '💡 $categoryName spending is $pct% over your threshold.',
      SuggestionSeverity.low =>
        'ℹ️ $categoryName is approaching your set limit ($pct% over).',
    };
  }

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        spent,
        threshold,
        overagePercent,
        severity,
      ];
}
