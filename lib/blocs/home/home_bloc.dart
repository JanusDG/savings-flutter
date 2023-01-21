import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/blocs/home/home_event.dart';
import 'package:savings_flutter/blocs/home/home_state.dart';
import 'package:savings_flutter/repositories/wallet_repository.dart';

import '../../models/wallet.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WalletRepository _walletRepository;
  final int uid;

  HomeBloc(this._walletRepository, this.uid) : super(HomeIdle()) {
    on<FetchWallets>((event, emit) async {
      try {
        emit(HomeLoading());
        List<Wallet> data = await _walletRepository.fetchWallets(uid);
        emit(HomeSuccess(wallets: data));
      } catch (e) {
        emit(HomeError(errorMsg: e.toString()));
      }
    });
  }
}
