import 'package:drift/drift.dart';
import '../../domain/entities/member.dart';
import '../local/database/app_database.dart';

class MemberMapper {
  const MemberMapper._();

  static Member fromData(MembersTableData data) => Member(
        id: data.id,
        name: data.name,
        emoji: data.emoji,
        color: data.color,
        isDefault: data.isDefault,
        createdAt: data.createdAt,
      );

  static MembersTableCompanion toCompanion(Member entity) =>
      MembersTableCompanion(
        id: Value(entity.id),
        name: Value(entity.name),
        emoji: Value(entity.emoji),
        color: Value(entity.color),
        isDefault: Value(entity.isDefault),
        createdAt: Value(entity.createdAt),
      );
}
