/// Data-layer exceptions that get mapped to domain Failures.
class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);
  @override
  String toString() => 'DatabaseException: $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}

class BackupException implements Exception {
  final String message;
  const BackupException(this.message);
  @override
  String toString() => 'BackupException: $message';
}
