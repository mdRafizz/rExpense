import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/shell/app_shell.dart';
import '../../presentation/dashboard/dashboard_screen.dart';
import '../../presentation/analytics/analytics_screen.dart';
import '../../presentation/transactions/add_transaction_screen.dart';
import '../../presentation/transactions/transaction_detail_screen.dart';
import '../../presentation/categories/categories_screen.dart';
import '../../presentation/categories/category_form_screen.dart';
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
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AnalyticsScreen(),
          ),
        ),
        GoRoute(
          path: '/categories',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CategoriesScreen(),
          ),
          routes: [
            GoRoute(
              path: 'new',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const CategoryFormScreen(),
            ),
            GoRoute(
              path: 'edit',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) {
                final category = state.extra as Category;
                return CategoryFormScreen(category: category);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),

    // Full-screen routes (outside shell)
    GoRoute(
      path: '/transactions/add',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return AddTransactionScreen(
          initialType: extra?['type'] as TransactionType?,
        );
      },
    ),
    GoRoute(
      path: '/transactions/edit',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final transaction = state.extra as Transaction;
        return AddTransactionScreen(existingTransaction: transaction);
      },
    ),
    GoRoute(
      path: '/transactions/detail',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final transaction = state.extra as Transaction;
        return TransactionDetailScreen(transaction: transaction);
      },
    ),
  ],
);
