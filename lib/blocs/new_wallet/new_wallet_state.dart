import 'package:equatable/equatable.dart';
import 'package:savings_flutter/models/currency.dart';

import '../../models/bank.dart';
import '../../models/wallet_type.dart';

class NewWalletState extends Equatable {
  const NewWalletState(
      {this.name = '',
      this.type,
      this.bank,
      this.balance = '',
      this.currency,
      this.isLoading = false,
      this.isSubmitted = false,
      this.error});

  final String name;
  final WalletType? type;
  final Bank? bank;
  final String balance;
  final Currency? currency;

  final bool isLoading;
  final bool isSubmitted;
  final String? error;

  NewWalletState copyWith(
          {String? name,
          WalletType? type,
          Bank? bank,
          String? balance,
          Currency? currency,
          bool? isLoading,
          bool? isSubmitted,
          String? error}) =>
      NewWalletState(
          name: name ?? this.name,
          type: type ?? this.type,
          bank: bank ?? this.bank,
          balance: balance ?? this.balance,
          currency: currency ?? this.currency,
          isLoading: isLoading ?? false,
          isSubmitted: isSubmitted ?? this.isSubmitted,
          error: error);

  @override
  List<Object?> get props => [name, type, bank, balance, currency, isLoading, isSubmitted, error];
}
