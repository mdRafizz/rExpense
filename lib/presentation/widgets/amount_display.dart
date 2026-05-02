import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction.dart';

/// Displays a monetary amount with appropriate color and sign.
class AmountDisplay extends StatelessWidget {
  final double amount;
  final TransactionType? type;
  final TextStyle? style;
  final bool showSign;
  final bool compact;

  const AmountDisplay({
    super.key,
    required this.amount,
    this.type,
    this.style,
    this.showSign = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = type == TransactionType.income;
    final color = type == null
        ? Theme.of(context).colorScheme.onSurface
        : isIncome
            ? AppColors.income
            : AppColors.expense;

    final sign = showSign && type != null ? (isIncome ? '+' : '-') : '';
    final formatted = compact
        ? CurrencyFormatter.compact(amount)
        : CurrencyFormatter.full(amount);

    return Text(
      '$sign$formatted',
      style: (style ?? AppTextStyles.amountMedium).copyWith(color: color),
    );
  }
}
