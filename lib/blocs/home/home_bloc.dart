import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/blocs/home/home_event.dart';
import 'package:savings_flutter/blocs/home/home_state.dart';
import 'package:savings_flutter/models/transaction.dart';
import 'package:savings_flutter/repositories/wallet_repository.dart';

import '../../models/bank.dart';
import '../../models/category.dart';
import '../../models/wallet.dart';
import '../../models/wallet_type.dart';
import '../../repositories/transaction_reporitory.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final TransactionRepository _transactionRepository;
  final WalletRepository walletRepository;
  final int uid;

  late List<Wallet> wallets;
  late List<WalletType> types;
  late List<Bank> banks;
  late List<Category> categories;

  HomeBloc(this.walletRepository, this._transactionRepository, this.uid)
      : super(HomeIdle()) {
    on<FetchWallets>((event, emit) async {
      try {
        emit(HomeLoading());
        types = await walletRepository.fetchWalletTypes();
        banks = await walletRepository.fetchBanks();
        categories = await _transactionRepository.fetchCategories();
        wallets = await walletRepository.fetchWallets(uid, types);

        if (wallets.isEmpty) {
          emit(HomeEmpty());
        } else {
          List<int> walletIds = [];
          for (var element in wallets) {
            walletIds.add(element.id!);
          }
          List<Transaction> transactions =
              await _transactionRepository.fetchUserTransactions(walletIds);
          transactions.sort((b, a) => (DateTime.parse(a.datetime))
              .compareTo(DateTime.parse(b.datetime)));
          emit(HomeSuccess(wallets: wallets, transactions: transactions));
        }
      } catch (e) {
        emit(HomeError(errorMsg: e.toString()));
      }
    });
  }
}
