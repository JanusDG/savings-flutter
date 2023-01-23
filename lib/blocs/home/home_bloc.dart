import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/blocs/home/home_event.dart';
import 'package:savings_flutter/blocs/home/home_state.dart';
import 'package:savings_flutter/repositories/wallet_repository.dart';

import '../../models/wallet.dart';
import '../../models/wallet_type.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WalletRepository _walletRepository;
  final int uid;
  List<WalletType> types = List.empty();

  HomeBloc(this._walletRepository, this.uid) : super(HomeIdle()) {
    on<FetchWallets>((event, emit) async {
      try {
        emit(HomeLoading());
        types = await _walletRepository.fetchWalletTypes();
        List<Wallet> wallets = await _walletRepository.fetchWallets(uid, types);
        if (wallets.isEmpty) {
          emit(HomeEmpty());
        } else {
          emit(HomeSuccess(wallets: wallets));
        }
      } catch (e) {
        emit(HomeError(errorMsg: e.toString()));
      }
    });
  }
}
