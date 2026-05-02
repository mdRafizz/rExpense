import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/members_table.dart';

part 'member_dao.g.dart';

@DriftAccessor(tables: [MembersTable])
class MemberDao extends DatabaseAccessor<AppDatabase> with _$MemberDaoMixin {
  MemberDao(super.db);

  /// Reactively emits all members.
  Stream<List<MembersTableData>> watchAll() =>
      (select(membersTable)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  /// Returns all members once.
  Future<List<MembersTableData>> getAll() =>
      (select(membersTable)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  /// Returns the default member (Family).
  Future<MembersTableData?> getDefault() =>
      (select(membersTable)..where((t) => t.isDefault.equals(true)))
          .getSingleOrNull();

  /// Returns a member by id.
  Future<MembersTableData?> getById(String id) =>
      (select(membersTable)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Inserts a new member.
  Future<void> insert(MembersTableCompanion companion) =>
      into(membersTable).insertOnConflictUpdate(companion);

  /// Updates a member.
  Future<bool> updateMember(MembersTableCompanion companion) =>
      update(membersTable).replace(companion);

  /// Deletes a member by id.
  Future<int> deleteById(String id) =>
      (delete(membersTable)..where((t) => t.id.equals(id))).go();
}
