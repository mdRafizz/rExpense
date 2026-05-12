import 'package:rexpense/domain/repositories/transaction_repository.dart';

class GetBalanceUseCase {
  final TransactionRepository _repository;

  const GetBalanceUseCase(this._repository);

  Future<double> execute({
    DateTime? startDate,
    DateTime? endDate,
    int? accountId,
  }) async {
    return await _repository.getNetBalance(
      startDate: startDate,
      endDate: endDate,
      accountId: accountId,
    );
  }
}
