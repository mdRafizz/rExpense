part of 'sync_cubit.dart';

sealed class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object?> get props => [];
}

final class SyncInitial extends SyncState {
  const SyncInitial();
}

final class SyncLoading extends SyncState {
  final String message;
  const SyncLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

final class SyncIdle extends SyncState {
  final String? signedInEmail;
  final DateTime? lastBackupTime;

  const SyncIdle({this.signedInEmail, this.lastBackupTime});

  bool get isSignedIn => signedInEmail != null;

  @override
  List<Object?> get props => [signedInEmail, lastBackupTime];
}

final class SyncSuccess extends SyncState {
  final String message;
  final String? signedInEmail;
  final DateTime? lastBackupTime;

  const SyncSuccess({
    required this.message,
    this.signedInEmail,
    this.lastBackupTime,
  });

  @override
  List<Object?> get props => [message, signedInEmail, lastBackupTime];
}

final class SyncError extends SyncState {
  final String message;
  const SyncError(this.message);

  @override
  List<Object?> get props => [message];
}
