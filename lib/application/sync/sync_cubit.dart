import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/repositories/sync_repository.dart';

part 'sync_state.dart';

/// Manages Google Drive backup/restore state.
class SyncCubit extends Cubit<SyncState> {
  final SyncRepository _repository;

  SyncCubit(this._repository) : super(const SyncInitial()) {
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    final email = await _repository.getSignedInEmail();
    final lastBackup = await _repository.getLastBackupTime();
    emit(SyncIdle(
      signedInEmail: email,
      lastBackupTime: lastBackup,
    ));
  }

  Future<void> signIn() async {
    emit(const SyncLoading(message: 'Signing in...'));
    final result = await _repository.signIn();
    result.fold(
      (failure) => emit(SyncError(failure.message)),
      (email) async {
        final lastBackup = await _repository.getLastBackupTime();
        emit(SyncIdle(signedInEmail: email, lastBackupTime: lastBackup));
      },
    );
  }

  Future<void> signOut() async {
    emit(const SyncLoading(message: 'Signing out...'));
    final result = await _repository.signOut();
    result.fold(
      (failure) => emit(SyncError(failure.message)),
      (_) => emit(const SyncIdle()),
    );
  }

  Future<void> backup() async {
    emit(const SyncLoading(message: 'Backing up to Google Drive...'));
    final result = await _repository.backup();
    result.fold(
      (failure) => emit(SyncError(failure.message)),
      (_) async {
        final lastBackup = await _repository.getLastBackupTime();
        final email = await _repository.getSignedInEmail();
        emit(SyncSuccess(
          message: 'Backup completed successfully',
          signedInEmail: email,
          lastBackupTime: lastBackup,
        ));
      },
    );
  }

  Future<void> restore() async {
    emit(const SyncLoading(message: 'Restoring from Google Drive...'));
    final result = await _repository.restore();
    result.fold(
      (failure) => emit(SyncError(failure.message)),
      (_) => emit(const SyncSuccess(
        message: 'Data restored. Please restart the app.',
      )),
    );
  }

  Future<void> triggerAutoBackupIfDue() async {
    final lastBackup = await _repository.getLastBackupTime();
    if (lastBackup == null ||
        DateTime.now().difference(lastBackup).inHours >= 24) {
      await backup();
    }
  }
}
