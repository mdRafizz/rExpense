import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/sync_repository.dart';
import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import '../../core/constants/app_constants.dart';
import '../local/database/app_database.dart';

class SyncRepositoryImpl implements SyncRepository {
  final GoogleSignIn _googleSignIn;
  final AppDatabase _db;

  SyncRepositoryImpl({
    required GoogleSignIn googleSignIn,
    required AppDatabase db,
  })  : _googleSignIn = googleSignIn,
        _db = db;

  @override
  Future<Either<Failure, String>> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return Left(const AuthFailure('Sign-in cancelled by user'));
      }
      return Right(account.email);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _googleSignIn.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<String?> getSignedInEmail() async {
    final account = _googleSignIn.currentUser ??
        await _googleSignIn.signInSilently();
    return account?.email;
  }

  @override
  Future<Either<Failure, void>> backup() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return Left(const AuthFailure('Not signed in to Google'));
      }

      final dbPath = await _db.getDatabasePath();
      final dbFile = File(dbPath);
      if (!dbFile.existsSync()) {
        return Left(const BackupFailure('Database file not found'));
      }

      // Check if backup already exists to update vs create
      final existingId = await _getExistingBackupFileId(driveApi);

      final media = drive.Media(
        dbFile.openRead(),
        dbFile.lengthSync(),
        contentType: 'application/octet-stream',
      );

      if (existingId != null) {
        // Update existing file
        await driveApi.files.update(
          drive.File(),
          existingId,
          uploadMedia: media,
        );
      } else {
        // Create new file in App Data folder
        final driveFileMetadata = drive.File()
          ..name = AppConstants.driveBackupFileName
          ..parents = [AppConstants.driveAppDataFolder];

        await driveApi.files.create(
          driveFileMetadata,
          uploadMedia: media,
        );
      }

      // Record backup timestamp
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.lastBackupKey,
        DateTime.now().toIso8601String(),
      );

      return const Right(null);
    } catch (e) {
      return Left(BackupFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> restore() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) {
        return Left(const AuthFailure('Not signed in to Google'));
      }

      final fileId = await _getExistingBackupFileId(driveApi);
      if (fileId == null) {
        return Left(const BackupFailure('No backup found in Google Drive'));
      }

      final response = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final dbPath = await _db.getDatabasePath();
      final tempPath = '$dbPath.restore_tmp';
      final tempFile = File(tempPath);

      final sink = tempFile.openWrite();
      await response.stream.pipe(sink);
      await sink.close();

      // Close the database before replacing the file
      await _db.close();

      // Replace the database file
      await tempFile.rename(dbPath);

      return const Right(null);
    } catch (e) {
      return Left(BackupFailure(e.toString()));
    }
  }

  @override
  Future<DateTime?> getLastBackupTime() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.lastBackupKey);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  @override
  Future<Either<Failure, bool>> hasRemoteBackup() async {
    try {
      final driveApi = await _getDriveApi();
      if (driveApi == null) return const Right(false);
      final id = await _getExistingBackupFileId(driveApi);
      return Right(id != null);
    } catch (e) {
      return Left(BackupFailure(e.toString()));
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<drive.DriveApi?> _getDriveApi() async {
    final account = _googleSignIn.currentUser ??
        await _googleSignIn.signInSilently();
    if (account == null) return null;

    final httpClient = await _googleSignIn.authenticatedClient();
    if (httpClient == null) return null;

    return drive.DriveApi(httpClient);
  }

  Future<String?> _getExistingBackupFileId(drive.DriveApi api) async {
    final list = await api.files.list(
      spaces: AppConstants.driveAppDataFolder,
      q: "name='${AppConstants.driveBackupFileName}'",
      $fields: 'files(id)',
    );
    return list.files?.firstOrNull?.id;
  }
}
