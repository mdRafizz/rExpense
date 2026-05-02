import '../entities/member.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';

abstract interface class MemberRepository {
  Stream<List<Member>> watchAll();
  Future<Either<Failure, List<Member>>> getAll();
  Future<Either<Failure, Member?>> getDefault();
  Future<Either<Failure, Member>> create(Member member);
  Future<Either<Failure, Member>> update(Member member);
  Future<Either<Failure, void>> delete(String id);
}
