import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../widgets/glass_card.dart';

class CategoryData {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;

  CategoryData({
    required this.name,
    required this.amount,
    required this.color,
    required this.icon,
  });

  double getPercentage(double total) => (amount / total) * 100;
}

class CategoryPieChart extends StatefulWidget {
  final List<CategoryData> categories;
  final Function(CategoryData)? onCategoryTap;

  const CategoryPieChart({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = widget.categories.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    final currencyFormat = NumberFormat.currency(symbol: '৳', decimalDigits: 0);

    return GlassCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Expense by Category',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              letterSpacing: -0.2,
            ),
          ),
          Gap(20.h),

          // Pie Chart
          SizedBox(
            height: 200.h,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = null;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 50.r,
                sections: List.generate(
                  widget.categories.length,
                  (i) {
                    final isTouched = i == touchedIndex;
                    final radius = isTouched ? 65.r : 55.r;
                    final category = widget.categories[i];
                    final percentage = category.getPercentage(total);

                    return PieChartSectionData(
                      color: category.color,
                      value: category.amount,
                      title: '${percentage.toStringAsFixed(1)}%',
                      radius: radius,
                      titleStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: isTouched ? 14.sp : 11.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      badgeWidget: isTouched
                          ? Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Icon(
                                category.icon,
                                size: 20.sp,
                                color: category.color,
                              ),
                            )
                          : null,
                      badgePositionPercentageOffset: 1.3,
                    );
                  },
                ),
              ),
            ),
          ),
          Gap(24.h),

          // Legend
          ...List.generate(
            widget.categories.length,
            (index) {
              final category = widget.categories[index];
              final percentage = category.getPercentage(total);

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: InkWell(
                  onTap: () => widget.onCategoryTap?.call(category),
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: touchedIndex == index
                          ? category.color.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: touchedIndex == index
                            ? category.color.withValues(alpha: 0.3)
                            : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Color indicator
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: category.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Gap(10.w),

                        // Icon
                        Icon(
                          category.icon,
                          size: 16.sp,
                          color: category.color,
                        ),
                        Gap(8.w),

                        // Name
                        Expanded(
                          child: Text(
                            category.name,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ),

                        // Percentage
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: category.color,
                          ),
                        ),
                        Gap(8.w),

                        // Amount
                        Text(
                          currencyFormat.format(category.amount),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
