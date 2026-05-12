import 'package:equatable/equatable.dart';

enum AccountType { cash, bank, mobileWallet, other }

class AccountEntity extends Equatable {
  final int id;
  final String name;
  final AccountType accountType;
  final double initialBalance;
  final String currency;
  final bool isActive;

  const AccountEntity({
    required this.id,
    required this.name,
    required this.accountType,
    this.initialBalance = 0.0,
    this.currency = '৳',
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, accountType, initialBalance, currency, isActive];
}