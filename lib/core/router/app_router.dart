import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/shell/app_shell.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/analytics/analytics_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/add_transaction/add_transaction_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (_, __) => const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (_, __) => const NoTransitionPage(child: AnalyticsPage()),
        ),
        GoRoute(
          path: '/categories',
          pageBuilder: (_, __) => NoTransitionPage(child: Scaffold(
            appBar: AppBar(title: const Text('Categories')),
            body: const Center(child: Text('Categories Page - Coming Soon')),
          )),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (_, __) => Scaffold(
                appBar: AppBar(title: const Text('New Category')),
                body: const Center(child: Text('New Category Page - Coming Soon')),
              ),
            ),
            GoRoute(
                path: 'edit',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, state) => Scaffold(
                  appBar: AppBar(title: const Text('Edit Category')),
                  body: const Center(child: Text('Edit Category Page - Coming Soon')),
                )),
          ],
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (_, __) => const NoTransitionPage(child: SettingsPage()),
        ),
      ],
    ),

    // ── Full-screen routes (outside shell) ────────────────────────────────
    GoRoute(
      path: '/categories/new',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => Scaffold(
        appBar: AppBar(title: const Text('New Category')),
        body: const Center(child: Text('New Category Page - Coming Soon')),
      ),
    ),
    GoRoute(
      path: '/categories/edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => Scaffold(
        appBar: AppBar(title: const Text('Edit Category')),
        body: const Center(child: Text('Edit Category Page - Coming Soon')),
      ),
    ),
    GoRoute(
      path: '/members',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => Scaffold(
        appBar: AppBar(title: const Text('Members')),
        body: const Center(child: Text('Members Page - Coming Soon')),
      ),
    ),
    GoRoute(
      path: '/transactions/add',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        return const AddTransactionPage();
      },
    ),
    GoRoute(
        path: '/transactions/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => Scaffold(
          appBar: AppBar(title: const Text('Edit Transaction')),
          body: const Center(child: Text('Edit Transaction Page - Coming Soon')),
        )),
    GoRoute(
      path: '/transactions/detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => Scaffold(
        appBar: AppBar(title: const Text('Transaction Detail')),
        body: const Center(child: Text('Transaction Detail Page - Coming Soon')),
      ),
    ),
  ],
);
