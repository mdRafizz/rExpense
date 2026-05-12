import 'package:rexpense/domain/repositories/transaction_repository.dart';

class GetExpensesByCategoryUseCase {
  final TransactionRepository _repository;

  const GetExpensesByCategoryUseCase(this._repository);

  Future<Map<String, double>> execute(DateTime month) async {
    return await _repository.getExpensesByCategory(month);
  }
}
