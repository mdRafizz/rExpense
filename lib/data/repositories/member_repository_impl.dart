import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../../core/logger/app_logger.dart';
import '../local/database/app_database.dart';
import '../mappers/member_mapper.dart';

class MemberRepositoryImpl implements MemberRepository {
  static const _tag = 'MemberRepo';
  final AppDatabase _db;

  const MemberRepositoryImpl(this._db);

  @override
  Stream<List<Member>> watchAll() {
    AppLogger.v(_tag, 'watchAll() subscribed');
    return _db.memberDao.watchAll().map(
      (rows) => rows.map(MemberMapper.fromData).toList(),
    );
  }

  @override
  Future<Either<Failure, List<Member>>> getAll() async {
    try {
      final rows = await _db.memberDao.getAll();
      AppLogger.d(_tag, 'getAll() → ${rows.length} members');
      return Right(rows.map(MemberMapper.fromData).toList());
    } catch (e, st) {
      AppLogger.e(_tag, 'getAll() failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Member?>> getDefault() async {
    try {
      final row = await _db.memberDao.getDefault();
      AppLogger.d(_tag, 'getDefault() → ${row?.name ?? 'none'}');
      return Right(row != null ? MemberMapper.fromData(row) : null);
    } catch (e, st) {
      AppLogger.e(_tag, 'getDefault() failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Member>> create(Member member) async {
    AppLogger.i(_tag, 'create() name="${member.name}"');
    try {
      await _db.memberDao.insert(MemberMapper.toCompanion(member));
      return Right(member);
    } catch (e, st) {
      AppLogger.e(_tag, 'create() failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Member>> update(Member member) async {
    AppLogger.i(_tag, 'update() id=${member.id}');
    try {
      await _db.memberDao.updateMember(MemberMapper.toCompanion(member));
      return Right(member);
    } catch (e, st) {
      AppLogger.e(_tag, 'update() failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    AppLogger.i(_tag, 'delete() id=$id');
    try {
      await _db.memberDao.deleteById(id);
      return const Right(null);
    } catch (e, st) {
      AppLogger.e(_tag, 'delete() failed', error: e, stackTrace: st);
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
