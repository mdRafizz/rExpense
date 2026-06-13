import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../widgets/glass_card.dart';

class CategoryExpenseData {
  final String categoryName;
  final double amount;
  final Color color;
  final IconData icon;

  CategoryExpenseData({
    required this.categoryName,
    required this.amount,
    required this.color,
    required this.icon,
  });
}

class CategoryExpenseGraph extends StatelessWidget {
  final List<CategoryExpenseData> categories;
  final Function(CategoryExpenseData)? onCategoryTap;

  const CategoryExpenseGraph({
    super.key,
    required this.categories,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxAmount = categories.fold<double>(
      0,
      (max, e) => e.amount > max ? e.amount : max,
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
            'Category-wise Expense',
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

          // Bar Chart
          SizedBox(
            height: 250.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxAmount * 1.2,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final category = categories[group.x.toInt()];
                      return BarTooltipItem(
                        '${category.categoryName}\n${currencyFormat.format(category.amount)}',
                        TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    if (response != null &&
                        response.spot != null &&
                        event is FlTapUpEvent) {
                      final index = response.spot!.touchedBarGroupIndex;
                      if (index >= 0 && index < categories.length) {
                        onCategoryTap?.call(categories[index]);
                      }
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50.h,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() < categories.length) {
                          final category = categories[value.toInt()];
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Column(
                              children: [
                                Icon(
                                  category.icon,
                                  size: 18.sp,
                                  color: category.color,
                                ),
                                Gap(4.h),
                                Text(
                                  category.categoryName,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? AppColors.textTertiaryDark
                                        : AppColors.textTertiaryLight,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40.w,
                      interval: maxAmount / 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000).toStringAsFixed(0)}k',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxAmount / 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark
                          ? AppColors.dividerDark.withValues(alpha: 0.3)
                          : AppColors.dividerLight.withValues(alpha: 0.5),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                barGroups: List.generate(
                  categories.length,
                  (index) {
                    final category = categories[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: category.amount,
                          gradient: LinearGradient(
                            colors: [
                              category.color,
                              category.color.withValues(alpha: 0.7),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          width: 24.w,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6.r),
                            topRight: Radius.circular(6.r),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxAmount * 1.2,
                            color: isDark
                                ? AppColors.cardDark.withValues(alpha: 0.5)
                                : const Color(0xFFF0F1F8),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Gap(16.h),

          // Tap hint
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.touch_app_rounded,
                  size: 14.sp,
                  color: AppColors.primary,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    'Tap on any category to view detailed history',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
