import '../entities/spending_suggestion.dart';
import '../repositories/category_repository.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/budget_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../../core/utils/date_utils.dart';

/// Identifies spending leaks in categories marked as 'unnecessary'
/// by comparing actual spend against user-set budget thresholds.
class DetectSpendingLeaks {
  final TransactionRepository _transactionRepo;
  final CategoryRepository _categoryRepo;
  final BudgetRepository _budgetRepo;

  const DetectSpendingLeaks(
    this._transactionRepo,
    this._categoryRepo,
    this._budgetRepo,
  );

  Future<Either<Failure, List<SpendingSuggestion>>> call({
    required int year,
    required int month,
  }) async {
    final monthKey = AppDateUtils.toMonthKey(DateTime(year, month));
    final start = AppDateUtils.startOfMonth(year, month);
    final end = AppDateUtils.endOfMonth(year, month);

    final categoriesResult = await _categoryRepo.getAll();
    if (categoriesResult.isLeft) return Left(categoriesResult.left);

    final summaryResult = await _transactionRepo.getSummary(start, end);
    if (summaryResult.isLeft) return Left(summaryResult.left);

    final budgetsResult = await _budgetRepo.getByMonth(monthKey);
    if (budgetsResult.isLeft) return Left(budgetsResult.left);

    final unnecessaryCategories = categoriesResult.right
        .where((c) => c.isUnnecessary)
        .toList();

    final expenseByCategory = summaryResult.right.expenseByCategory;
    final budgetMap = {
      for (final b in budgetsResult.right) b.categoryId: b.monthlyLimit,
    };

    final suggestions = <SpendingSuggestion>[];

    for (final category in unnecessaryCategories) {
      final spent = expenseByCategory[category.id] ?? 0.0;
      final threshold = budgetMap[category.id];

      // Skip if no budget set or not enough spend to matter
      if (threshold == null || threshold <= 0) continue;
      if (spent <= threshold) continue;

      final overagePercent = ((spent - threshold) / threshold) * 100;

      final severity = overagePercent >= 50
          ? SuggestionSeverity.high
          : overagePercent >= 20
              ? SuggestionSeverity.medium
              : SuggestionSeverity.low;

      suggestions.add(SpendingSuggestion(
        categoryId: category.id,
        categoryName: category.name,
        spent: spent,
        threshold: threshold,
        overagePercent: overagePercent,
        severity: severity,
      ));
    }

    // Sort by severity then overage
    suggestions.sort((a, b) {
      final severityCompare = b.severity.index.compareTo(a.severity.index);
      if (severityCompare != 0) return severityCompare;
      return b.overagePercent.compareTo(a.overagePercent);
    });

    return Right(suggestions);
  }
}
