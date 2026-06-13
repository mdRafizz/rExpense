import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../widgets/glass_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/transaction_providers.dart';
import 'widgets/balance_card.dart';
import 'widgets/transaction_list_item.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    // Watch data from providers
    final netBalanceAsync = ref.watch(netBalanceProvider());
    final monthlyIncomeAsync = ref.watch(monthlyIncomeProvider);
    final monthlyExpenseAsync = ref.watch(monthlyExpenseProvider);
    final todayTransactionsAsync = ref.watch(todayTransactionsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'rExpense',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(now),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  size: 22.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              Gap(8.w),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(8.h),

                // Balance Card
                netBalanceAsync.when(
                  data: (netBalance) => monthlyIncomeAsync.when(
                    data: (income) => monthlyExpenseAsync.when(
                      data: (expense) => BalanceCard(
                        netBalance: netBalance,
                        monthlyIncome: income,
                        monthlyExpense: expense,
                      ),
                      loading: () => _LoadingBalanceCard(),
                      error: (_, __) => _ErrorCard(),
                    ),
                    loading: () => _LoadingBalanceCard(),
                    error: (_, __) => _ErrorCard(),
                  ),
                  loading: () => _LoadingBalanceCard(),
                  error: (_, __) => _ErrorCard(),
                ),
                Gap(24.h),

                // Quick Actions
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: _QuickActionButton(
                          label: 'All Expenses',
                          icon: Icons.arrow_upward_rounded,
                          color: AppColors.expense,
                          onTap: () {},
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: _QuickActionButton(
                          label: 'All Income',
                          icon: Icons.arrow_downward_rounded,
                          color: AppColors.income,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(24.h),

                // Today's Transactions Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          letterSpacing: -0.3,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View All',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(12.h),

                // Transaction List
                todayTransactionsAsync.when(
                  data: (transactions) {
                    if (transactions.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48.sp,
                                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                              ),
                              Gap(12.h),
                              Text(
                                'No transactions today',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: transactions.map((txn) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: TransactionListItem(
                              categoryName: txn.category.name,
                              categoryColor: Color(txn.category.colorInt ?? AppColors.categoryPalette[0].value),
                              categoryIcon: _getCategoryIcon(txn.category.name),
                              beneficiaryName: txn.beneficiary?.name,
                              contributorName: txn.contributor?.name,
                              amount: txn.transaction.amount,
                              transactionType: txn.transaction.transactionType,
                              date: txn.transaction.transactionDate,
                              notes: txn.transaction.notes,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                  loading: () => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: List.generate(3, (index) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: _LoadingTransactionItem(),
                      )),
                    ),
                  ),
                  error: (_, __) => _ErrorCard(),
                ),
                Gap(100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    if (categoryName.contains('🛒') || categoryName.contains('Grocery')) return Icons.shopping_cart_outlined;
    if (categoryName.contains('🥚') || categoryName.contains('Egg')) return Icons.egg_outlined;
    if (categoryName.contains('🍖') || categoryName.contains('Meat')) return Icons.restaurant_outlined;
    if (categoryName.contains('🏠') || categoryName.contains('Rent')) return Icons.home_outlined;
    if (categoryName.contains('⚡') || categoryName.contains('Utilities')) return Icons.bolt_outlined;
    if (categoryName.contains('🚌') || categoryName.contains('Transport')) return Icons.directions_car_outlined;
    if (categoryName.contains('✈️') || categoryName.contains('Travel')) return Icons.flight_outlined;
    if (categoryName.contains('📚') || categoryName.contains('Education')) return Icons.school_outlined;
    if (categoryName.contains('💊') || categoryName.contains('Medical')) return Icons.local_hospital_outlined;
    if (categoryName.contains('🍽️') || categoryName.contains('Restaurant')) return Icons.restaurant_menu_outlined;
    if (categoryName.contains('🎉') || categoryName.contains('Entertainment')) return Icons.movie_outlined;
    if (categoryName.contains('🤲') || categoryName.contains('Sadaqah')) return Icons.volunteer_activism_outlined;
    if (categoryName.contains('💰') || categoryName.contains('Salary')) return Icons.account_balance_wallet_outlined;
    if (categoryName.contains('🎁') || categoryName.contains('Gift')) return Icons.card_giftcard_outlined;
    if (categoryName.contains('📈') || categoryName.contains('Business')) return Icons.business_outlined;
    return Icons.category_outlined;
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        margin: EdgeInsets.zero,
        borderRadius: 14.r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 16.sp, color: color),
            ),
            Gap(8.w),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingBalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Container(
            height: 20.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          Gap(8.h),
          Container(
            height: 40.h,
            width: 200.w,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingTransactionItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Gap(6.h),
                Container(
                  height: 10.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4.r),
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

class _ErrorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GlassCard(
        margin: EdgeInsets.zero,
        child: Center(
          child: Text(
            'Error loading data',
            style: TextStyle(fontFamily: 'Inter', fontSize: 14.sp, color: AppColors.danger),
          ),
        ),
      ),
    );
  }
}
