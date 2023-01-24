import 'package:equatable/equatable.dart';
import 'package:savings_flutter/models/currency.dart';

import '../../models/bank.dart';
import '../../models/wallet_type.dart';

class NewWalletEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangeName extends NewWalletEvent {
  ChangeName({required this.name});

  final String name;
}

class ChangeType extends NewWalletEvent {
  ChangeType({required this.type});

  final WalletType type;
}

class ChangeBank extends NewWalletEvent {
  ChangeBank({required this.bank});

  final Bank bank;
}

class ChangeBalance extends NewWalletEvent {
  ChangeBalance({required this.balance});

  final String balance;
}

class ChangeCurrency extends NewWalletEvent {
  ChangeCurrency({required this.currency});

  final Currency currency;
}

class SubmitNewWallet extends NewWalletEvent {}
