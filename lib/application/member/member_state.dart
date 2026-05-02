part of 'member_cubit.dart';

sealed class MemberState extends Equatable {
  const MemberState();
  @override
  List<Object?> get props => [];
}

final class MemberLoading extends MemberState {
  const MemberLoading();
}

final class MemberLoaded extends MemberState {
  final List<Member> members;
  final String? activeMemberId;

  const MemberLoaded({required this.members, this.activeMemberId});

  Member? get activeMember =>
      members.where((m) => m.id == activeMemberId).firstOrNull;

  MemberLoaded copyWith({
    List<Member>? members,
    String? activeMemberId,
  }) =>
      MemberLoaded(
        members: members ?? this.members,
        activeMemberId: activeMemberId ?? this.activeMemberId,
      );

  @override
  List<Object?> get props => [members, activeMemberId];
}

final class MemberError extends MemberState {
  final String message;
  const MemberError(this.message);
  @override
  List<Object?> get props => [message];
}
