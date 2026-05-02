/// Date utility helpers used across the app.
class AppDateUtils {
  AppDateUtils._();

  /// Returns the first moment of the given month.
  static DateTime startOfMonth(int year, int month) =>
      DateTime(year, month, 1);

  /// Returns the last moment of the given month.
  static DateTime endOfMonth(int year, int month) =>
      DateTime(year, month + 1, 1).subtract(const Duration(microseconds: 1));

  /// Returns the first moment of the given year.
  static DateTime startOfYear(int year) => DateTime(year, 1, 1);

  /// Returns the last moment of the given year.
  static DateTime endOfYear(int year) =>
      DateTime(year + 1, 1, 1).subtract(const Duration(microseconds: 1));

  /// Formats a DateTime to 'YYYY-MM' string.
  static String toMonthKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  /// Parses a 'YYYY-MM' string to a DateTime (first day of month).
  static DateTime fromMonthKey(String key) {
    final parts = key.split('-');
    return DateTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  /// Returns a list of [count] months ending at [end] (inclusive).
  static List<DateTime> lastNMonths(DateTime end, int count) {
    final months = <DateTime>[];
    for (int i = count - 1; i >= 0; i--) {
      final month = DateTime(end.year, end.month - i, 1);
      months.add(month);
    }
    return months;
  }

  /// Returns a list of [count] years ending at [end] (inclusive).
  static List<int> lastNYears(int end, int count) =>
      List.generate(count, (i) => end - (count - 1 - i));

  /// Checks if two DateTimes are in the same month.
  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  /// Returns the previous month's DateTime.
  static DateTime previousMonth(DateTime date) =>
      DateTime(date.year, date.month - 1, 1);

  /// Returns the next month's DateTime.
  static DateTime nextMonth(DateTime date) =>
      DateTime(date.year, date.month + 1, 1);
}
