import 'dart:ui';

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

  FlutterError.onError = (FlutterErrorDetails details) {
    AppLogger.f(
      'Flutter',
      details.exceptionAsString(),
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  Bloc.observer = AppBlocObserver();
  AppLogger.i('App', '━━━ rExpense starting ━━━');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await configureDependencies();
  AppLogger.i('App', 'Dependency injection configured');

  sl<SyncCubit>().triggerAutoBackupIfDue();

  runApp(const RexpenseApp());
}

class RexpenseApp extends StatelessWidget {
  const RexpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const _BouncingScrollBehavior(),
      child: _BackPressHandler(
        child: MaterialApp.router(
          title: 'rExpense',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}

// ── Root-level back-press handler ─────────────────────────────────────────────
// Wraps the entire app so it intercepts the Android back button before
// GoRouter or any navigator can handle it.

class _BackPressHandler extends StatelessWidget {
  final Widget child;
  const _BackPressHandler({required this.child});

  static Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      barrierDismissible: false,
      builder: (_) => const _ExitDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Never allow the default pop — we decide what happens
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        // Ask GoRouter what the current location is
        final router = appRouter;
        final location = router.routerDelegate.currentConfiguration.uri.path;

        final isAtRoot = location == '/dashboard' ||
            location == '/analytics' ||
            location == '/categories' ||
            location == '/settings';

        if (!isAtRoot) {
          // We're inside a full-screen route (add/edit/detail) — let it pop
          // by re-enabling pop for one frame via the navigator directly.
          if (context.mounted) {
            final nav = Navigator.maybeOf(context);
            if (nav != null && nav.canPop()) {
              nav.pop();
            }
          }
          return;
        }

        if (location != '/dashboard') {
          // On a non-home tab — go back to dashboard
          if (context.mounted) appRouter.go('/dashboard');
          return;
        }

        // On dashboard — show exit dialog
        if (!context.mounted) return;
        final shouldExit = await _showExitDialog(context);
        if (shouldExit && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}

// ── iOS-style liquid glass exit dialog ───────────────────────────────────────

class _ExitDialog extends StatelessWidget {
  const _ExitDialog();

  @override
  Widget build(BuildContext context) {
    // We need the theme from the MaterialApp child, so use Builder
    return Builder(builder: (ctx) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      final colorScheme = Theme.of(ctx).colorScheme;

      return Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1C1C1E).withValues(alpha: 0.88)
                        : Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : Colors.white.withValues(alpha: 0.75),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 40,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),

                      // ── Icon ──────────────────────────────────────────────
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFFFF6584).withValues(alpha: 0.25),
                              const Color(0xFFFF6584).withValues(alpha: 0.08),
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFF6584)
                                .withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.power_settings_new_rounded,
                          color: Color(0xFFFF6584),
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // ── Title ─────────────────────────────────────────────
                      Text(
                        'Exit rExpense?',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // ── Subtitle ──────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Are you sure you want to close the app?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),

                      // ── Divider ───────────────────────────────────────────
                      Container(
                        height: 0.5,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.1),
                      ),

                      // ── Buttons ───────────────────────────────────────────
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            // Cancel
                            Expanded(
                              child: _GlassButton(
                                label: 'Cancel',
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                onTap: () => Navigator.of(ctx).pop(false),
                              ),
                            ),
                            // Vertical divider
                            Container(
                              width: 0.5,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.1),
                            ),
                            // Exit
                            Expanded(
                              child: _GlassButton(
                                label: 'Exit',
                                color: const Color(0xFFFF6584),
                                fontWeight: FontWeight.w600,
                                onTap: () => Navigator.of(ctx).pop(true),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _GlassButton extends StatelessWidget {
  final String label;
  final Color color;
  final FontWeight fontWeight;
  final VoidCallback onTap;

  const _GlassButton({
    required this.label,
    required this.color,
    required this.fontWeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: fontWeight,
            color: color,
            letterSpacing: -0.1,
          ),
        ),
      ),
    );
  }
}

// ── Bounce scroll behaviour ───────────────────────────────────────────────────

/// Forces [BouncingScrollPhysics] on every scrollable in the widget tree,
/// including [ListView], [SingleChildScrollView], [CustomScrollView], etc.
class _BouncingScrollBehavior extends ScrollBehavior {
  const _BouncingScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      // Remove the Android glow/stretch indicator — iOS has none
      child;
}
