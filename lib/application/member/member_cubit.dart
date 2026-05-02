import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../../core/logger/app_logger.dart';

part 'member_state.dart';

class MemberCubit extends Cubit<MemberState> {
  static const _tag = 'MemberCubit';

  final MemberRepository _repository;
  final _uuid = const Uuid();
  StreamSubscription<List<Member>>? _sub;

  String? _activeMemberId;
  String? get activeMemberId => _activeMemberId;

  MemberCubit(this._repository) : super(const MemberLoading()) {
    AppLogger.d(_tag, 'created');
    _subscribe();
  }

  void _subscribe() {
    _sub?.cancel();
    _sub = _repository.watchAll().listen(
      (members) {
        AppLogger.v(_tag, 'stream emitted ${members.length} members');
        if (_activeMemberId == null) {
          final def = members.where((m) => m.isDefault).firstOrNull;
          _activeMemberId = def?.id;
        }
        emit(MemberLoaded(members: members, activeMemberId: _activeMemberId));
      },
      onError: (e, st) {
        AppLogger.e(_tag, 'stream error', error: e, stackTrace: st);
        emit(MemberError(e.toString()));
      },
    );
  }

  void selectMember(String? memberId) {
    AppLogger.i(_tag, 'selectMember() → $memberId');
    _activeMemberId = memberId;
    final current = state;
    if (current is MemberLoaded) {
      emit(current.copyWith(activeMemberId: memberId));
    }
  }

  String? get effectiveMemberId {
    final current = state;
    if (current is MemberLoaded) {
      return _activeMemberId ??
          current.members.where((m) => m.isDefault).firstOrNull?.id;
    }
    return null;
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  Future<void> addMember({
    required String name,
    required String emoji,
    required int color,
  }) async {
    AppLogger.i(_tag, 'addMember() name="$name"');
    final member = Member(
      id: 'member_${_uuid.v4().substring(0, 8)}',
      name: name.trim(),
      emoji: emoji,
      color: color,
      isDefault: false,
      createdAt: DateTime.now(),
    );
    final result = await _repository.create(member);
    result.fold(
      (f) {
        AppLogger.e(_tag, 'addMember() failed → ${f.message}');
        emit(MemberError(f.message));
      },
      (_) => AppLogger.i(_tag, 'addMember() success — stream will update'),
    );
  }

  Future<void> updateMember(Member member) async {
    AppLogger.i(_tag, 'updateMember() id=${member.id}');
    final result = await _repository.update(member);
    result.fold(
      (f) {
        AppLogger.e(_tag, 'updateMember() failed → ${f.message}');
        emit(MemberError(f.message));
      },
      (_) => AppLogger.i(_tag, 'updateMember() success'),
    );
  }

  Future<void> deleteMember(String id) async {
    AppLogger.i(_tag, 'deleteMember() id=$id');
    // If deleting the active member, fall back to default
    if (_activeMemberId == id) {
      final current = state;
      if (current is MemberLoaded) {
        final def = current.members
            .where((m) => m.isDefault && m.id != id)
            .firstOrNull;
        _activeMemberId = def?.id;
      }
    }
    final result = await _repository.delete(id);
    result.fold(
      (f) {
        AppLogger.e(_tag, 'deleteMember() failed → ${f.message}');
        emit(MemberError(f.message));
      },
      (_) => AppLogger.i(_tag, 'deleteMember() success'),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
