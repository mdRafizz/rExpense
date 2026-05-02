import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/repositories/sync_repository.dart';
import '../../core/logger/app_logger.dart';

part 'sync_state.dart';

/// Manages Google Drive backup/restore state.
class SyncCubit extends Cubit<SyncState> {
  static const _tag = 'SyncCubit';

  final SyncRepository _repository;

  SyncCubit(this._repository) : super(const SyncInitial()) {
    AppLogger.d(_tag, 'created — loading initial state');
    _loadInitialState();
  }

  Future<void> _loadInitialState() async {
    AppLogger.d(_tag, '_loadInitialState() checking sign-in status');
    final email = await _repository.getSignedInEmail();
    final lastBackup = await _repository.getLastBackupTime();
    AppLogger.i(_tag,
      '_loadInitialState() → '
      'email=${email ?? 'none'} '
      'lastBackup=${lastBackup ?? 'never'}',
    );
    emit(SyncIdle(signedInEmail: email, lastBackupTime: lastBackup));
  }

  Future<void> signIn() async {
    AppLogger.i(_tag, 'signIn() requested');
    emit(const SyncLoading(message: 'Signing in...'));
    final result = await _repository.signIn();
    result.fold(
      (failure) {
        AppLogger.e(_tag, 'signIn() failed → ${failure.message}');
        emit(SyncError(failure.message));
      },
      (email) async {
        AppLogger.i(_tag, 'signIn() success → $email');
        final lastBackup = await _repository.getLastBackupTime();
        emit(SyncIdle(signedInEmail: email, lastBackupTime: lastBackup));
      },
    );
  }

  Future<void> signOut() async {
    AppLogger.i(_tag, 'signOut() requested');
    emit(const SyncLoading(message: 'Signing out...'));
    final result = await _repository.signOut();
    result.fold(
      (failure) {
        AppLogger.e(_tag, 'signOut() failed → ${failure.message}');
        emit(SyncError(failure.message));
      },
      (_) {
        AppLogger.i(_tag, 'signOut() success');
        emit(const SyncIdle());
      },
    );
  }

  Future<void> backup() async {
    AppLogger.i(_tag, 'backup() requested');
    emit(const SyncLoading(message: 'Backing up to Google Drive...'));
    final result = await _repository.backup();
    result.fold(
      (failure) {
        AppLogger.e(_tag, 'backup() failed → ${failure.message}');
        emit(SyncError(failure.message));
      },
      (_) async {
        final lastBackup = await _repository.getLastBackupTime();
        final email = await _repository.getSignedInEmail();
        AppLogger.i(_tag, 'backup() success — lastBackup=$lastBackup');
        emit(SyncSuccess(
          message: 'Backup completed successfully',
          signedInEmail: email,
          lastBackupTime: lastBackup,
        ));
      },
    );
  }

  Future<void> restore() async {
    AppLogger.i(_tag, 'restore() requested');
    emit(const SyncLoading(message: 'Restoring from Google Drive...'));
    final result = await _repository.restore();
    result.fold(
      (failure) {
        AppLogger.e(_tag, 'restore() failed → ${failure.message}');
        emit(SyncError(failure.message));
      },
      (_) {
        AppLogger.i(_tag, 'restore() success — restart required');
        emit(const SyncSuccess(
          message: 'Data restored. Please restart the app.',
        ));
      },
    );
  }

  Future<void> triggerAutoBackupIfDue() async {
    final lastBackup = await _repository.getLastBackupTime();
    final isDue = lastBackup == null ||
        DateTime.now().difference(lastBackup).inHours >= 24;
    AppLogger.i(_tag,
      'triggerAutoBackupIfDue() → '
      'lastBackup=${lastBackup ?? 'never'} '
      'isDue=$isDue',
    );
    if (isDue) await backup();
  }
}
