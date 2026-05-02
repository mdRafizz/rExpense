// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';

/// Log levels in ascending severity order.
enum LogLevel { verbose, debug, info, warning, error, fatal }

/// Centralized logger with ANSI color output in debug mode.
///
/// Usage:
///   AppLogger.i('Dashboard', 'Loaded 12 transactions');
///   AppLogger.e('SyncRepo', 'Sign-in failed', error: e, stackTrace: st);
class AppLogger {
  AppLogger._();

  // ── ANSI color codes ───────────────────────────────────────────────────────
  static const _reset   = '\x1B[0m';
  static const _bold    = '\x1B[1m';
  static const _grey    = '\x1B[90m';   // verbose
  static const _cyan    = '\x1B[96m';   // debug
  static const _green   = '\x1B[92m';   // info
  static const _yellow  = '\x1B[93m';   // warning
  static const _red     = '\x1B[91m';   // error
  static const _magenta = '\x1B[95m';   // fatal

  static const _levelMeta = {
    LogLevel.verbose : ('V', _grey),
    LogLevel.debug   : ('D', _cyan),
    LogLevel.info    : ('I', _green),
    LogLevel.warning : ('W', _yellow),
    LogLevel.error   : ('E', _red),
    LogLevel.fatal   : ('F', _magenta),
  };

  /// Minimum level to print. Raise to [LogLevel.warning] in staging.
  static LogLevel minLevel = kDebugMode ? LogLevel.verbose : LogLevel.warning;

  // ── Public API ─────────────────────────────────────────────────────────────

  static void v(String tag, String message) =>
      _log(LogLevel.verbose, tag, message);

  static void d(String tag, String message) =>
      _log(LogLevel.debug, tag, message);

  static void i(String tag, String message) =>
      _log(LogLevel.info, tag, message);

  static void w(String tag, String message, {Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.warning, tag, message, error: error, stackTrace: stackTrace);

  static void e(String tag, String message, {Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.error, tag, message, error: error, stackTrace: stackTrace);

  static void f(String tag, String message, {Object? error, StackTrace? stackTrace}) =>
      _log(LogLevel.fatal, tag, message, error: error, stackTrace: stackTrace);

  // ── Core ───────────────────────────────────────────────────────────────────

  static void _log(
    LogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.index < minLevel.index) return;

    final (symbol, color) = _levelMeta[level]!;
    final time = _timestamp();

    // Main line
    final line = '$color$_bold[$symbol]$_reset '
        '$_grey$time$_reset '
        '$color$_bold$tag$_reset '
        '$color$message$_reset';

    print(line);

    // Error object
    if (error != null) {
      print('$color$_bold  ↳ ${error.runtimeType}:$_reset $color$error$_reset');
    }

    // Stack trace — print first 8 frames to keep it readable
    if (stackTrace != null) {
      final frames = stackTrace.toString().trim().split('\n');
      final preview = frames.take(8).map((f) => '    $f').join('\n');
      print('$_grey$preview$_reset');
      if (frames.length > 8) {
        print('$_grey    ... ${frames.length - 8} more frames$_reset');
      }
    }
  }

  static String _timestamp() {
    final now = DateTime.now();
    final h  = now.hour.toString().padLeft(2, '0');
    final m  = now.minute.toString().padLeft(2, '0');
    final s  = now.second.toString().padLeft(2, '0');
    final ms = now.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s.$ms';
  }
}
