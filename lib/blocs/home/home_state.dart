import 'package:equatable/equatable.dart';

import '../../models/wallet.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeIdle extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<Wallet> wallets;
  HomeSuccess({required this.wallets});
}

class HomeError extends HomeState {
  final String errorMsg;
  HomeError({required this.errorMsg});
}
