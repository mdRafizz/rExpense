import '../../core/utils/either.dart';
import '../../core/error/failures.dart';
import 'category_repository.dart';

/// Contract for Google Drive backup/restore operations.
abstract interface class SyncRepository {
  /// Signs the user in with Google OAuth2.
  Future<Either<Failure, String>> signIn();

  /// Signs the user out.
  Future<Either<Failure, Unit>> signOut();

  /// Returns the currently signed-in user's email, or null.
  Future<String?> getSignedInEmail();

  /// Uploads the local database file to Google Drive App Data folder.
  Future<Either<Failure, Unit>> backup();

  /// Downloads and restores the database from Google Drive.
  Future<Either<Failure, Unit>> restore();

  /// Returns the timestamp of the last successful backup, or null.
  Future<DateTime?> getLastBackupTime();

  /// Checks if a backup file exists in Drive.
  Future<Either<Failure, bool>> hasRemoteBackup();
}
