import 'package:flutter/material.dart';
import 'package:r_expense/core/theme/AppTheme.dart';
import 'package:r_expense/features/dashboard/presentation/dashboard_view.dart';

class RExpenseApp extends StatelessWidget {
  const RExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rExpense',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const DashboardView(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fredoka Font Demo', style: TextStyles.headline6()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Light font (300)
            Text('Light (300)', style: TextStyles.headline6(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text('This is light weight text (300)', style: TextStyles.light()),
            const SizedBox(height: 16),
            
            // Regular font (400)
            Text('Regular (400)', style: TextStyles.headline6(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text('This is regular weight text (400)', style: TextStyles.regular()),
            const SizedBox(height: 16),
            
            // Medium font (500)
            Text('Medium (500)', style: TextStyles.headline6(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text('This is medium weight text (500)', style: TextStyles.medium()),
            const SizedBox(height: 16),
            
            // SemiBold font (600)
            Text('SemiBold (600)', style: TextStyles.headline6(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text('This is semi-bold weight text (600)', style: TextStyles.semiBold()),
            const SizedBox(height: 16),
            
            // Bold font (700)
            Text('Bold (700)', style: TextStyles.headline6(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text('This is bold weight text (700)', style: TextStyles.bold()),
            const SizedBox(height: 16),
            
            // Headline styles
            Text('Headline Styles', style: TextStyles.headline5(color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 8),
            Text('Headline 1', style: TextStyles.headline1()),
            Text('Headline 2', style: TextStyles.headline2()),
            Text('Headline 3', style: TextStyles.headline3()),
            Text('Headline 4', style: TextStyles.headline4()),
            Text('Headline 5', style: TextStyles.headline5()),
            Text('Headline 6', style: TextStyles.headline6()),
          ],
        ),
      ),
    );
  }
}
