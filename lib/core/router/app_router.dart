import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/shell/app_shell.dart';

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
          pageBuilder: (_, __) => const NoTransitionPage(child: Scaffold()),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (_, __) => const NoTransitionPage(child: Scaffold()),
        ),
        GoRoute(
          path: '/categories',
          pageBuilder: (_, __) => NoTransitionPage(child: Scaffold()),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (_, __) => Scaffold(),
            ),
            GoRoute(
                path: 'edit',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (_, state) => Scaffold()),
          ],
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (_, __) => const NoTransitionPage(child: Scaffold()),
        ),
      ],
    ),

    // ── Full-screen routes (outside shell) ────────────────────────────────
    GoRoute(
      path: '/categories/new',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => Scaffold(),
    ),
    GoRoute(
      path: '/categories/edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => Scaffold(),
    ),
    GoRoute(
      path: '/members',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => Scaffold(),
    ),
    GoRoute(
      path: '/transactions/add',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return Scaffold();
      },
    ),
    GoRoute(
        path: '/transactions/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => Scaffold()),
    GoRoute(
      path: '/transactions/detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => Scaffold(),
    ),
  ],
);
