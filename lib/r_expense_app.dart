import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:r_expense/core/theme/app_tehme.dart';

class RExpenseApp extends StatelessWidget {
  const RExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rExpense',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: ThemeManager(),
    );
  }
}

