import 'package:equatable/equatable.dart';
import 'package:savings_flutter/models/transaction.dart';

import '../../models/wallet.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeIdle extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Wallet> wallets;
  final List<Transaction> transactions;
  HomeSuccess({required this.wallets, required this.transactions});
  @override
  List<Object> get props => [transactions];
}

class HomeError extends HomeState {
  final String errorMsg;
  HomeError({required this.errorMsg});
}
