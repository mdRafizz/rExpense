import 'package:intl/intl.dart';

/// Formats monetary values consistently across the app.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final _compact = NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 1,
  );

  static final _full = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static final _plain = NumberFormat('#,##0.00');

  /// Formats a value compactly: $1.2K, $3.4M
  static String compact(double value) => _compact.format(value);

  /// Formats a value fully: $1,234.56
  static String full(double value) => _full.format(value);

  /// Formats without currency symbol: 1,234.56
  static String plain(double value) => _plain.format(value);

  /// Formats a percentage: +15.0% or -8.3%
  static String percent(double value, {bool showSign = true}) {
    final sign = showSign && value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(1)}%';
  }
}
