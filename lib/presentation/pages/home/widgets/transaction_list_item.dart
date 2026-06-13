import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

class TransactionListItem extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  final IconData categoryIcon;
  final String? beneficiaryName;
  final String? contributorName;
  final double amount;
  final String transactionType;
  final DateTime date;
  final String? notes;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
    this.beneficiaryName,
    this.contributorName,
    required this.amount,
    required this.transactionType,
    required this.date,
    this.notes,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(symbol: '৳', decimalDigits: 0);
    final timeFormat = DateFormat('hh:mm a');
    final isExpense = transactionType == 'expense';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.cardDark.withValues(alpha: 0.5)
              : AppColors.cardLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark
                ? AppColors.dividerDark.withValues(alpha: 0.5)
                : AppColors.dividerLight.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: categoryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                categoryIcon,
                size: 20.sp,
                color: categoryColor,
              ),
            ),
            Gap(12.w),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                      letterSpacing: -0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(2.h),
                  Row(
                    children: [
                      if (beneficiaryName != null) ...[
                        Icon(
                          Icons.person_outline_rounded,
                          size: 12.sp,
                          color: isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                        ),
                        Gap(3.w),
                        Text(
                          beneficiaryName!,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? AppColors.textTertiaryDark
                                : AppColors.textTertiaryLight,
                          ),
                        ),
                        Gap(6.w),
                      ],
                      Icon(
                        Icons.access_time_rounded,
                        size: 12.sp,
                        color: isDark
                            ? AppColors.textTertiaryDark
                            : AppColors.textTertiaryLight,
                      ),
                      Gap(3.w),
                      Text(
                        timeFormat.format(date),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Gap(8.w),

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isExpense ? '-' : '+'}${currencyFormat.format(amount)}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: isExpense ? AppColors.expense : AppColors.income,
                    letterSpacing: -0.2,
                  ),
                ),
                if (notes != null && notes!.isNotEmpty) ...[
                  Gap(2.h),
                  Icon(
                    Icons.note_outlined,
                    size: 12.sp,
                    color: isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiaryLight,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
