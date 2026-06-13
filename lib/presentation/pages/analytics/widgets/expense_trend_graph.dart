import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../widgets/glass_card.dart';

class DailyExpense {
  final DateTime date;
  final double amount;

  DailyExpense({required this.date, required this.amount});
}

class ExpenseTrendGraph extends StatelessWidget {
  final List<DailyExpense> expenses;
  final bool isBeautified;
  final VoidCallback onToggleBeautify;

  const ExpenseTrendGraph({
    super.key,
    required this.expenses,
    required this.isBeautified,
    required this.onToggleBeautify,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate beautified data
    final maxAmount = expenses.fold<double>(
      0,
      (max, e) => e.amount > max ? e.amount : max,
    );
    final avgAmount = expenses.fold<double>(0, (sum, e) => sum + e.amount) /
        expenses.length;

    // Beautify outliers
    final displayExpenses = isBeautified
        ? expenses.map((e) {
            // If amount is more than 3x average, compress it
            if (e.amount > avgAmount * 3) {
              final compressed = avgAmount * 2 + (e.amount - avgAmount * 3) * 0.2;
              return DailyExpense(date: e.date, amount: compressed);
            }
            return e;
          }).toList()
        : expenses;

    final displayMax = displayExpenses.fold<double>(
      0,
      (max, e) => e.amount > max ? e.amount : max,
    );

    return GlassCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Expense Trend',
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
              GestureDetector(
                onTap: onToggleBeautify,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: isBeautified
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : (isDark
                            ? AppColors.cardDark
                            : const Color(0xFFF0F1F8)),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isBeautified
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isBeautified
                            ? Icons.auto_awesome_rounded
                            : Icons.show_chart_rounded,
                        size: 14.sp,
                        color: isBeautified
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight),
                      ),
                      Gap(4.w),
                      Text(
                        isBeautified ? 'Beautified' : 'Original',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: isBeautified
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gap(20.h),

          // Graph
          SizedBox(
            height: 200.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: displayExpenses.length * 40.w,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: displayMax / 5,
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
                          reservedSize: 30.h,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < displayExpenses.length) {
                              final date = displayExpenses[value.toInt()].date;
                              return Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  DateFormat('dd').format(date),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? AppColors.textTertiaryDark
                                        : AppColors.textTertiaryLight,
                                  ),
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
                          interval: displayMax / 5,
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
                    minX: 0,
                    maxX: (displayExpenses.length - 1).toDouble(),
                    minY: 0,
                    maxY: displayMax * 1.1,
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          displayExpenses.length,
                          (index) => FlSpot(
                            index.toDouble(),
                            displayExpenses[index].amount,
                          ),
                        ),
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.expense,
                            AppColors.expense.withValues(alpha: 0.7),
                          ],
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            // Show special indicator for beautified outliers
                            final isOutlier = isBeautified &&
                                expenses[index].amount > avgAmount * 3;
                            return FlDotCirclePainter(
                              radius: isOutlier ? 5 : 3,
                              color: Colors.white,
                              strokeWidth: isOutlier ? 2.5 : 2,
                              strokeColor: AppColors.expense,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.expense.withValues(alpha: 0.3),
                              AppColors.expense.withValues(alpha: 0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final index = spot.x.toInt();
                            final originalAmount = expenses[index].amount;
                            final date = expenses[index].date;
                            final isOutlier = isBeautified &&
                                originalAmount > avgAmount * 3;

                            return LineTooltipItem(
                              '${DateFormat('MMM dd').format(date)}\n৳${NumberFormat('#,##0').format(originalAmount)}${isOutlier ? '\n(Beautified)' : ''}',
                              TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Beautify explanation
          if (isBeautified) ...[
            Gap(12.h),
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
                    Icons.info_outline_rounded,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  Gap(8.w),
                  Expanded(
                    child: Text(
                      'Outliers are compressed for better visualization. Dots with borders indicate beautified values.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
