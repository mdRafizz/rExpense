import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/database_provider.dart';
import '../../../data/local/database/app_database.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/pill_chip.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  bool isExpense = true;
  final amountController = TextEditingController();
  final notesController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  CategoryTableData? selectedCategory;
  BeneficiaryTableData? selectedBeneficiary;
  ContributorTableData? selectedContributor;
  AccountTableData? selectedAccount;

  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Transaction',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.close_rounded, size: 24.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Type Selector
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PillChip(
                    icon: Icons.arrow_upward_rounded,
                    label: 'Expense',
                    isSelected: isExpense,
                    accentColor: AppColors.expense,
                    bgColor: isDark ? AppColors.cardDark : const Color(0xFFF0F1F8),
                    onTap: () {
                      setState(() {
                        isExpense = true;
                        selectedCategory = null;
                      });
                    },
                  ),
                  Gap(12.w),
                  PillChip(
                    icon: Icons.arrow_downward_rounded,
                    label: 'Income',
                    isSelected: !isExpense,
                    accentColor: AppColors.income,
                    bgColor: isDark ? AppColors.cardDark : const Color(0xFFF0F1F8),
                    onTap: () {
                      setState(() {
                        isExpense = false;
                        selectedCategory = null;
                      });
                    },
                  ),
                ],
              ),
            ),
            Gap(24.h),

            // Amount Input
            GlassCard(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Gap(8.h),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: isExpense ? AppColors.expense : AppColors.income,
                      letterSpacing: -1,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textTertiaryDark.withValues(alpha: 0.5)
                            : AppColors.textTertiaryLight.withValues(alpha: 0.5),
                      ),
                      prefixText: '৳ ',
                      prefixStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: isExpense ? AppColors.expense : AppColors.income,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            Gap(16.h),

            // Category Selection
            _SelectionTile(
              icon: Icons.category_outlined,
              label: 'Category',
              value: selectedCategory?.name ?? 'Select category',
              iconColor: AppColors.categoryPalette[0],
              onTap: _showCategoryPicker,
            ),
            Gap(12.h),

            // Date Selection
            _SelectionTile(
              icon: Icons.calendar_today_rounded,
              label: 'Date',
              value: DateFormat('MMM dd, yyyy').format(selectedDate),
              iconColor: AppColors.primary,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
            ),
            Gap(12.h),

            // Account Selection
            _SelectionTile(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Account',
              value: selectedAccount?.name ?? 'Select account',
              iconColor: AppColors.categoryPalette[4],
              onTap: _showAccountPicker,
            ),
            Gap(12.h),

            // Beneficiary/Contributor Selection
            if (isExpense)
              _SelectionTile(
                icon: Icons.person_outline_rounded,
                label: 'Beneficiary',
                value: selectedBeneficiary?.name ?? 'Select beneficiary (Optional)',
                iconColor: AppColors.categoryPalette[2],
                onTap: _showBeneficiaryPicker,
              )
            else
              _SelectionTile(
                icon: Icons.people_outline_rounded,
                label: 'Contributor',
                value: selectedContributor?.name ?? 'Select contributor (Optional)',
                iconColor: AppColors.categoryPalette[1],
                onTap: _showContributorPicker,
              ),
            Gap(12.h),

            // Notes Input
            GlassCard(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: notesController,
                maxLines: 3,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                decoration: InputDecoration(
                  hintText: 'Add notes (Optional)',
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            Gap(24.h),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isExpense ? AppColors.expense : AppColors.income,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                ),
                child: Text(
                  'Save Transaction',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
            Gap(16.h),
          ],
        ),
      ),
    );
  }

  Future<void> _showCategoryPicker() async {
    final categories = isExpense
        ? await ref.read(categoryDaoProvider).getCategoriesByType('expense')
        : await ref.read(categoryDaoProvider).getCategoriesByType('income');

    if (!mounted) return;

    final selected = await showModalBottomSheet<CategoryTableData>(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Category', style: TextStyle(fontFamily: 'Inter', fontSize: 18.sp, fontWeight: FontWeight.w700)),
            Gap(16.h),
            ...categories.map((category) => ListTile(
              leading: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Color(category.colorInt ?? AppColors.categoryPalette[0].value).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.category_outlined, color: Color(category.colorInt ?? AppColors.categoryPalette[0].value)),
              ),
              title: Text(category.name),
              onTap: () => Navigator.pop(context, category),
            )),
          ],
        ),
      ),
    );

    if (selected != null) setState(() => selectedCategory = selected);
  }

  Future<void> _showAccountPicker() async {
    final accounts = await ref.read(accountDaoProvider).getAllAccounts();
    if (!mounted) return;

    final selected = await showModalBottomSheet<AccountTableData>(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Account', style: TextStyle(fontFamily: 'Inter', fontSize: 18.sp, fontWeight: FontWeight.w700)),
            Gap(16.h),
            ...accounts.map((account) => ListTile(
              leading: Icon(Icons.account_balance_wallet_outlined),
              title: Text(account.name),
              onTap: () => Navigator.pop(context, account),
            )),
          ],
        ),
      ),
    );

    if (selected != null) setState(() => selectedAccount = selected);
  }

  Future<void> _showBeneficiaryPicker() async {
    final beneficiaries = await ref.read(beneficiaryDaoProvider).getAllBeneficiaries();
    if (!mounted) return;

    final selected = await showModalBottomSheet<BeneficiaryTableData>(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Beneficiary', style: TextStyle(fontFamily: 'Inter', fontSize: 18.sp, fontWeight: FontWeight.w700)),
            Gap(16.h),
            ...beneficiaries.map((beneficiary) => ListTile(
              leading: Icon(Icons.person_outline_rounded),
              title: Text(beneficiary.name),
              onTap: () => Navigator.pop(context, beneficiary),
            )),
          ],
        ),
      ),
    );

    if (selected != null) setState(() => selectedBeneficiary = selected);
  }

  Future<void> _showContributorPicker() async {
    final contributors = await ref.read(contributorDaoProvider).getAllContributors();
    if (!mounted) return;

    final selected = await showModalBottomSheet<ContributorTableData>(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Contributor', style: TextStyle(fontFamily: 'Inter', fontSize: 18.sp, fontWeight: FontWeight.w700)),
            Gap(16.h),
            ...contributors.map((contributor) => ListTile(
              leading: Icon(Icons.people_outline_rounded),
              title: Text(contributor.name),
              onTap: () => Navigator.pop(context, contributor),
            )),
          ],
        ),
      ),
    );

    if (selected != null) setState(() => selectedContributor = selected);
  }

  Future<void> _saveTransaction() async {
    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter amount'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select category'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    if (selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select account'), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    try {
      await ref.read(transactionDaoProvider).insertTransaction(
            amount: double.parse(amountController.text),
            dateTime: selectedDate,
            transactionType: isExpense ? 'expense' : 'income',
            categoryId: selectedCategory!.id,
            accountId: selectedAccount!.id,
            notes: notesController.text.isEmpty ? null : notesController.text,
            contributorId: selectedContributor?.id,
            beneficiaryId: selectedBeneficiary?.id,
          );

      if (mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${isExpense ? 'Expense' : 'Income'} added successfully'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.danger),
        );
      }
    }
  }
}

class _SelectionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final VoidCallback onTap;

  const _SelectionTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 20.sp, color: iconColor),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      letterSpacing: 0.2,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            ),
          ],
        ),
      ),
    );
  }
}
