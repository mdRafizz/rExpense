import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/database/app_database.dart';
import 'database_provider.dart';

part 'category_providers.g.dart';

// Watch all categories
@riverpod
Stream<List<CategoryTableData>> allCategories(AllCategoriesRef ref) {
  final dao = ref.watch(categoryDaoProvider);
  return dao.watchAllCategories();
}

// Watch expense categories
@riverpod
Stream<List<CategoryTableData>> expenseCategories(ExpenseCategoriesRef ref) {
  final dao = ref.watch(categoryDaoProvider);
  return dao.watchCategoriesByType('expense');
}

// Watch income categories
@riverpod
Stream<List<CategoryTableData>> incomeCategories(IncomeCategoriesRef ref) {
  final dao = ref.watch(categoryDaoProvider);
  return dao.watchCategoriesByType('income');
}

// Get category by id
@riverpod
Future<CategoryTableData?> categoryById(
  CategoryByIdRef ref,
  int id,
) async {
  final dao = ref.watch(categoryDaoProvider);
  return dao.getCategoryById(id);
}
