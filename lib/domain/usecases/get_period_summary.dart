import '../entities/period_summary.dart';
import '../repositories/transaction_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';

class GetPeriodSummary {
  final TransactionRepository _repository;

  const GetPeriodSummary(this._repository);

  Future<Either<Failure, PeriodSummary>> call(
    DateTime start,
    DateTime end,
  ) =>
      _repository.getSummary(start, end);

  Stream<PeriodSummary> watch(DateTime start, DateTime end) =>
      _repository.watchSummary(start, end);
}
