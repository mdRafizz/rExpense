import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import 'widgets/date_range_selector.dart';
import 'widgets/category_pie_chart.dart';
import 'widgets/expense_trend_graph.dart';
import 'widgets/category_expense_graph.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late DateTime fromDate;
  late DateTime toDate;
  bool isBeautified = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current month
    final now = DateTime.now();
    fromDate = DateTime(now.year, now.month, 1);
    toDate = DateTime(now.year, now.month + 1, 0);
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: fromDate, end: toDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // TODO: Replace with actual data from database
    final categoryData = [
      CategoryData(
        name: 'Groceries',
        amount: 8000,
        color: AppColors.categoryPalette[0],
        icon: Icons.shopping_cart_outlined,
      ),
      CategoryData(
        name: 'Transport',
        amount: 3000,
        color: AppColors.categoryPalette[2],
        icon: Icons.directions_car_outlined,
      ),
      CategoryData(
        name: 'Food',
        amount: 5000,
        color: AppColors.categoryPalette[3],
        icon: Icons.restaurant_outlined,
      ),
      CategoryData(
        name: 'Entertainment',
        amount: 2000,
        color: AppColors.categoryPalette[4],
        icon: Icons.movie_outlined,
      ),
    ];

    final dailyExpenses = List.generate(
      30,
      (index) => DailyExpense(
        date: DateTime.now().subtract(Duration(days: 29 - index)),
        amount: index == 0
            ? 20000
            : (500 + (index * 100) % 2000).toDouble(), // First day has outlier
      ),
    );

    final categoryExpenses = [
      CategoryExpenseData(
        categoryName: 'Groceries',
        amount: 8000,
        color: AppColors.categoryPalette[0],
        icon: Icons.shopping_cart_outlined,
      ),
      CategoryExpenseData(
        categoryName: 'Transport',
        amount: 3000,
        color: AppColors.categoryPalette[2],
        icon: Icons.directions_car_outlined,
      ),
      CategoryExpenseData(
        categoryName: 'Food',
        amount: 5000,
        color: AppColors.categoryPalette[3],
        icon: Icons.restaurant_outlined,
      ),
      CategoryExpenseData(
        categoryName: 'Bills',
        amount: 4000,
        color: AppColors.categoryPalette[5],
        icon: Icons.receipt_long_outlined,
      ),
      CategoryExpenseData(
        categoryName: 'Health',
        amount: 2500,
        color: AppColors.categoryPalette[6],
        icon: Icons.local_hospital_outlined,
      ),
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Analytics',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(8.h),

                  // Date Range Selector
                  DateRangeSelector(
                    fromDate: fromDate,
                    toDate: toDate,
                    onTap: _selectDateRange,
                  ),
                  Gap(20.h),

                  // Pie Chart
                  CategoryPieChart(
                    categories: categoryData,
                    onCategoryTap: (category) {
                      // TODO: Navigate to category detail
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Viewing ${category.name} details'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  Gap(20.h),

                  // Expense Trend Graph
                  ExpenseTrendGraph(
                    expenses: dailyExpenses,
                    isBeautified: isBeautified,
                    onToggleBeautify: () {
                      setState(() {
                        isBeautified = !isBeautified;
                      });
                      // TODO: Save to SharedPreferences
                    },
                  ),
                  Gap(20.h),

                  // Category Expense Graph
                  CategoryExpenseGraph(
                    categories: categoryExpenses,
                    onCategoryTap: (category) {
                      // TODO: Navigate to category history
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Viewing ${category.categoryName} history',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  Gap(24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
