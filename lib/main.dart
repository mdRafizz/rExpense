import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/logger/app_logger.dart';
import 'core/logger/bloc_logger.dart';
import 'application/sync/sync_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Global Flutter error handler ──────────────────────────────────────────
  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.f(
      'Flutter',
      details.exceptionAsString(),
      error: details.exception,
      stackTrace: details.stack,
    );
    // Still forward to the default handler so red-screen shows in debug
    FlutterError.presentError(details);
  };

  // ── Catch async errors outside Flutter's zone ─────────────────────────────
  // (e.g. isolate errors, unawaited futures)
  // Wrapped in the runZonedGuarded call below in runApp.

  // ── BLoC observer ─────────────────────────────────────────────────────────
  Bloc.observer = AppBlocObserver();

  AppLogger.i('App', '━━━ rExpense starting ━━━');

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure dependency injection
  await configureDependencies();
  AppLogger.i('App', 'Dependency injection configured');

  // Trigger auto-backup silently on startup (if signed in and due)
  sl<SyncCubit>().triggerAutoBackupIfDue();

  runApp(const RexpenseApp());
}

class RexpenseApp extends StatelessWidget {
  const RexpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'rExpense',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
