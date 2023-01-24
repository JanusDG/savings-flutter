import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/blocs/home/home_event.dart';
import 'package:savings_flutter/blocs/home/home_state.dart';
import 'package:savings_flutter/models/transaction.dart';
import 'package:savings_flutter/repositories/wallet_repository.dart';

import '../../models/wallet.dart';
import '../../repositories/transaction_reporitory.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WalletRepository _walletRepository;
  final TransactionRepository _transactionRepository;
  final int uid;

  HomeBloc(this._walletRepository, this._transactionRepository, this.uid)
      : super(HomeIdle()) {
    on<FetchWallets>((event, emit) async {
      try {
        emit(HomeLoading());
        List<Wallet> walletsData = await _walletRepository.fetchWallets(uid);
        List<int> walletIds = [];
        for (var element in walletsData) {
          walletIds.add(element.id!);
        }
        List<Transaction> transactions =
            await _transactionRepository.fetchUserTransactions(walletIds);
        emit(HomeSuccess(wallets: walletsData, transactions: transactions));
      } catch (e) {
        emit(HomeError(errorMsg: e.toString()));
      }
    });
  }
}
