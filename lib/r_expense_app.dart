import 'package:flutter/material.dart';
import 'package:r_expense/core/theme/app_theme.dart';

import 'features/dashboard/presentation/dashboard_view.dart';

class RExpenseApp extends StatelessWidget {
  const RExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rExpense',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: DashboardView(),
    );
  }
}
