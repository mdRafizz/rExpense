import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/sync_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../../core/constants/app_constants.dart';
import '../../core/logger/app_logger.dart';
import '../local/database/app_database.dart';

class SyncRepositoryImpl implements SyncRepository {
  static const _tag = 'SyncRepo';

  final GoogleSignIn _googleSignIn;
  final AppDatabase _db;

  SyncRepositoryImpl({
    required GoogleSignIn googleSignIn,
    required AppDatabase db,
  })  : _googleSignIn = googleSignIn,
        _db = db;

  // ── Sign-in ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, String>> signIn() async {
    AppLogger.i(_tag, 'signIn() called');
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        AppLogger.w(_tag, 'signIn() cancelled by user');
        return Left(const AuthFailure('Sign-in cancelled by user'));
      }
      AppLogger.i(_tag, 'signIn() success → ${account.email}');
      return Right(account.email);
    } catch (e, st) {
      AppLogger.e(_tag, 'signIn() threw an exception', error: e, stackTrace: st);
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    AppLogger.i(_tag, 'signOut() called');
    try {
      await _googleSignIn.signOut();
      AppLogger.i(_tag, 'signOut() success');
      return const Right(null);
    } catch (e, st) {
      AppLogger.e(_tag, 'signOut() failed', error: e, stackTrace: st);
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<String?> getSignedInEmail() async {
    AppLogger.v(_tag, 'getSignedInEmail() — checking current user');
    final account = _googleSignIn.currentUser ??
        await _googleSignIn.signInSilently();
    AppLogger.v(_tag, 'getSignedInEmail() → ${account?.email ?? 'null (not signed in)'}');
    return account?.email;
  }

  // ── Backup ─────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> backup() async {
    AppLogger.i(_tag, 'backup() started');
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        AppLogger.w(_tag, 'backup() aborted — not signed in to Google');
        return Left(const AuthFailure('Not signed in to Google'));
      }

      final dbPath = await _db.getDatabasePath();
      AppLogger.d(_tag, 'backup() db path → $dbPath');

      final dbFile = File(dbPath);
      if (!dbFile.existsSync()) {
        AppLogger.e(_tag, 'backup() failed — database file not found at $dbPath');
        return Left(const BackupFailure('Database file not found'));
      }

      final fileSize = dbFile.lengthSync();
      AppLogger.d(_tag, 'backup() db size → ${_formatBytes(fileSize)}');

      final existingId = await _getExistingBackupFileId(driveApi);
      AppLogger.d(_tag, 'backup() existing Drive file id → ${existingId ?? 'none (will create)'}');

      final media = drive.Media(
        dbFile.openRead(),
        fileSize,
        contentType: 'application/octet-stream',
      );

      if (existingId != null) {
        AppLogger.d(_tag, 'backup() updating existing Drive file');
        await driveApi.files.update(drive.File(), existingId, uploadMedia: media);
      } else {
        AppLogger.d(_tag, 'backup() creating new Drive file');
        final meta = drive.File()
          ..name = AppConstants.driveBackupFileName
          ..parents = [AppConstants.driveAppDataFolder];
        await driveApi.files.create(meta, uploadMedia: media);
      }

      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      await prefs.setString(AppConstants.lastBackupKey, now.toIso8601String());

      AppLogger.i(_tag, 'backup() completed successfully at $now');
      return const Right(null);
    } catch (e, st) {
      AppLogger.e(_tag, 'backup() threw an exception', error: e, stackTrace: st);
      return Left(BackupFailure(e.toString()));
    }
  }

  // ── Restore ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, void>> restore() async {
    AppLogger.i(_tag, 'restore() started');
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        AppLogger.w(_tag, 'restore() aborted — not signed in to Google');
        return Left(const AuthFailure('Not signed in to Google'));
      }

      final fileId = await _getExistingBackupFileId(driveApi);
      if (fileId == null) {
        AppLogger.w(_tag, 'restore() aborted — no backup found in Drive');
        return Left(const BackupFailure('No backup found in Google Drive'));
      }

      AppLogger.d(_tag, 'restore() downloading Drive file id → $fileId');
      final response = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final dbPath = await _db.getDatabasePath();
      final tempPath = '$dbPath.restore_tmp';
      AppLogger.d(_tag, 'restore() writing to temp file → $tempPath');

      final tempFile = File(tempPath);
      final sink = tempFile.openWrite();
      await response.stream.pipe(sink);
      await sink.close();

      AppLogger.d(_tag, 'restore() closing database before swap');
      await _db.close();

      AppLogger.d(_tag, 'restore() swapping temp file → $dbPath');
      await tempFile.rename(dbPath);

      AppLogger.i(_tag, 'restore() completed — app restart required');
      return const Right(null);
    } catch (e, st) {
      AppLogger.e(_tag, 'restore() threw an exception', error: e, stackTrace: st);
      return Left(BackupFailure(e.toString()));
    }
  }

  // ── Misc ───────────────────────────────────────────────────────────────────

  @override
  Future<DateTime?> getLastBackupTime() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.lastBackupKey);
    if (raw == null) {
      AppLogger.v(_tag, 'getLastBackupTime() → never backed up');
      return null;
    }
    final dt = DateTime.tryParse(raw);
    AppLogger.v(_tag, 'getLastBackupTime() → $dt');
    return dt;
  }

  @override
  Future<Either<Failure, bool>> hasRemoteBackup() async {
    AppLogger.v(_tag, 'hasRemoteBackup() checking');
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        AppLogger.v(_tag, 'hasRemoteBackup() → false (not signed in)');
        return const Right(false);
      }
      final id = await _getExistingBackupFileId(driveApi);
      AppLogger.v(_tag, 'hasRemoteBackup() → ${id != null}');
      return Right(id != null);
    } catch (e, st) {
      AppLogger.e(_tag, 'hasRemoteBackup() failed', error: e, stackTrace: st);
      return Left(BackupFailure(e.toString()));
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<drive.DriveApi?> _getDriveApi() async {
    AppLogger.v(_tag, '_getDriveApi() resolving account');
    final account = _googleSignIn.currentUser ??
        await _googleSignIn.signInSilently();
    if (account == null) {
      AppLogger.v(_tag, '_getDriveApi() → null (no account)');
      return null;
    }
    AppLogger.v(_tag, '_getDriveApi() account → ${account.email}');

    final httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient == null) {
      AppLogger.w(_tag, '_getDriveApi() → null (authenticatedClient returned null)');
      return null;
    }
    AppLogger.v(_tag, '_getDriveApi() authenticated client obtained');
    return drive.DriveApi(httpClient);
  }

  Future<String?> _getExistingBackupFileId(drive.DriveApi api) async {
    AppLogger.v(_tag, '_getExistingBackupFileId() querying Drive');
    final list = await api.files.list(
      spaces: AppConstants.driveAppDataFolder,
      q: "name='${AppConstants.driveBackupFileName}'",
      $fields: 'files(id)',
    );
    final id = list.files?.firstOrNull?.id;
    AppLogger.v(_tag, '_getExistingBackupFileId() → ${id ?? 'not found'}');
    return id;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)}MB';
  }
}
