import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/shell/app_shell.dart';
import '../../presentation/dashboard/dashboard_screen.dart';
import '../../presentation/analytics/analytics_screen.dart';
import '../../presentation/transactions/add_transaction_screen.dart';
import '../../presentation/transactions/transaction_detail_screen.dart';
import '../../presentation/categories/categories_screen.dart';
import '../../presentation/categories/category_form_screen.dart';
import '../../presentation/members/members_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/category.dart';

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
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: DashboardScreen()),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: AnalyticsScreen()),
        ),
        GoRoute(
          path: '/categories',
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: CategoriesScreen()),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (_, __) => const CategoryFormScreen(),
            ),
            GoRoute(
              path: 'edit',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (_, state) =>
                  CategoryFormScreen(category: state.extra as Category),
            ),
          ],
        ),
        GoRoute(
          path: '/members',
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: MembersScreen()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (_, __) =>
              const NoTransitionPage(child: SettingsScreen()),
        ),
      ],
    ),

    // ── Full-screen routes (outside shell) ────────────────────────────────
    GoRoute(
      path: '/transactions/add',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return AddTransactionScreen(
          initialType: extra?['type'] as TransactionType?,
          initialCategoryId: extra?['categoryId'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/transactions/edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) =>
          AddTransactionScreen(existingTransaction: state.extra as Transaction),
    ),
    GoRoute(
      path: '/transactions/detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) =>
          TransactionDetailScreen(transaction: state.extra as Transaction),
    ),
  ],
);
