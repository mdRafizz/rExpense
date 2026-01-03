import 'package:flutter/material.dart';
import 'package:r_expense/core/theme/AppTheme.dart';

class RExpenseApp extends StatelessWidget {
  const RExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rExpense',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const Scaffold(
          body: Center(child: Text('Welcome to rExpense!'))),
    );
  }
}
