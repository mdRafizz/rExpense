/// Central constants for the rexpense application.
class AppConstants {
  AppConstants._();

  // App metadata
  static const String appName = 'Rexpense';
  static const String appVersion = '1.0.0';

  // Google Drive
  static const String driveBackupFileName = 'rexpense_backup.db';
  static const String driveAppDataFolder = 'appDataFolder';

  // Backup schedule
  static const int backupIntervalHours = 24;
  static const String lastBackupKey = 'last_backup_timestamp';

  // Suggestion thresholds
  static const double defaultSpendingLeakThreshold = 0.15; // 15% over budget
  static const int minTransactionsForSuggestion = 3;

  // Chart
  static const int monthlyChartMonths = 6;
  static const int yearlyChartYears = 3;

  // Pagination
  static const int transactionPageSize = 30;

  // Category colors (hex)
  static const List<int> categoryColors = [
    0xFF6C63FF, // Violet
    0xFF43B89C, // Teal
    0xFFFF6584, // Rose
    0xFFFFBE0B, // Amber
    0xFF3A86FF, // Blue
    0xFFFF9F1C, // Orange
    0xFF8338EC, // Purple
    0xFF06D6A0, // Mint
    0xFFEF476F, // Crimson
    0xFF118AB2, // Cerulean
  ];
}
