import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/blocs/new_wallet/new_wallet_event.dart';
import 'package:savings_flutter/blocs/new_wallet/new_wallet_state.dart';
import 'package:savings_flutter/constants/app_strings.dart';
import 'package:savings_flutter/repositories/wallet_repository.dart';

import '../../models/bank.dart';
import '../../models/wallet.dart';
import '../../models/wallet_type.dart';

class NewWalletBloc extends Bloc<NewWalletEvent, NewWalletState> {
  final WalletRepository _walletRepository;
  final int uid;
  final List<WalletType> types;
  final List<Bank> banks;

  NewWalletBloc(this._walletRepository, this.uid, this.types, this.banks)
      : super(const NewWalletState()) {
    on<ChangeName>((event, emit) => emit(state.copyWith(name: event.name)));
    on<ChangeType>((event, emit) => emit(state.copyWith(type: event.type)));
    on<ChangeBank>((event, emit) => emit(state.copyWith(bank: event.bank)));
    on<ChangeBalance>(
        (event, emit) => emit(state.copyWith(balance: event.balance)));
    on<ChangeCurrency>(
        (event, emit) => emit(state.copyWith(currency: event.currency)));
    on<SubmitNewWallet>((event, emit) {
      emit(state.copyWith(isLoading: true));
      String? error = getError(state, emit);
      if (error == null) {
        try {
          _walletRepository.addNewWallet(Wallet(
              id: 0,
              typeId: state.type!.id,
              userId: uid,
              name: state.name,
              balance: (double.parse(state.balance) * 10).round(),
              currency: state.currency!.name,
              bankId: state.bank!.id));

          emit(state.copyWith(isSubmitted: true));
        } catch (e) {
          emit(state.copyWith(error: e.toString()));
        }
      } else {
        emit(state.copyWith(error: error));
      }
    });
  }

  String? getError(NewWalletState state, Emitter<NewWalletState> emit) {
    if (state.name == '') {
      return AppStrings.emptyError(AppStrings.name);
    }
    if (state.type == null) {
      return AppStrings.emptyError(AppStrings.type);
    }
    if (state.bank == null) {
      return AppStrings.emptyError(AppStrings.bank);
    }
    if (state.balance == '') {
      return AppStrings.emptyError(AppStrings.balance);
    }
    if (double.tryParse(state.balance) == null) {
      return AppStrings.numberError(AppStrings.balance);
    }
    if (state.currency == null) {
      return AppStrings.emptyError(AppStrings.currency);
    }
    return null;
  }
}
