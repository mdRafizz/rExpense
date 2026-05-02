import '../entities/variance_insight.dart';
import '../repositories/category_repository.dart';
import '../repositories/transaction_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';

/// Calculates period-over-period variance per category.
///
/// Example output: "You spent 15% more on Coffee this month than last"
class CalculateVariance {
  final TransactionRepository _transactionRepo;
  final CategoryRepository _categoryRepo;

  const CalculateVariance(this._transactionRepo, this._categoryRepo);

  Future<Either<Failure, List<VarianceInsight>>> call({
    required DateTime currentStart,
    required DateTime currentEnd,
    required DateTime previousStart,
    required DateTime previousEnd,
  }) async {
    final currentResult =
        await _transactionRepo.getSummary(currentStart, currentEnd);
    final previousResult =
        await _transactionRepo.getSummary(previousStart, previousEnd);
    final categoriesResult = await _categoryRepo.getAll();

    if (currentResult.isLeft) return Left(currentResult.left);
    if (previousResult.isLeft) return Left(previousResult.left);
    if (categoriesResult.isLeft) return Left(categoriesResult.left);

    final current = currentResult.right;
    final previous = previousResult.right;
    final categories = categoriesResult.right;

    final categoryMap = {for (final c in categories) c.id: c.name};

    // Merge all category ids from both periods
    final allCategoryIds = {
      ...current.expenseByCategory.keys,
      ...previous.expenseByCategory.keys,
    };

    final insights = <VarianceInsight>[];

    for (final categoryId in allCategoryIds) {
      final currentAmount = current.expenseByCategory[categoryId] ?? 0.0;
      final previousAmount = previous.expenseByCategory[categoryId] ?? 0.0;
      final categoryName = categoryMap[categoryId] ?? 'Unknown';

      double variancePercent;
      VarianceDirection direction;

      if (previousAmount == 0 && currentAmount == 0) continue;

      if (previousAmount == 0) {
        variancePercent = 100.0;
        direction = VarianceDirection.up;
      } else {
        variancePercent =
            ((currentAmount - previousAmount) / previousAmount) * 100;
        direction = variancePercent > 1
            ? VarianceDirection.up
            : variancePercent < -1
                ? VarianceDirection.down
                : VarianceDirection.neutral;
      }

      insights.add(VarianceInsight(
        categoryId: categoryId,
        categoryName: categoryName,
        currentAmount: currentAmount,
        previousAmount: previousAmount,
        variancePercent: variancePercent,
        direction: direction,
      ));
    }

    // Sort by absolute variance descending (most significant first)
    insights.sort(
      (a, b) =>
          b.variancePercent.abs().compareTo(a.variancePercent.abs()),
    );

    return Right(insights);
  }
}
