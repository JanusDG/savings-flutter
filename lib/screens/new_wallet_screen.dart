import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/blocs/new_wallet/new_wallet_bloc.dart';
import 'package:savings_flutter/blocs/new_wallet/new_wallet_event.dart';
import 'package:savings_flutter/constants/app_strings.dart';
import 'package:savings_flutter/models/currency.dart';
import 'package:savings_flutter/models/wallet_type.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';
import '../blocs/new_wallet/new_wallet_state.dart';
import '../models/bank.dart';

class NewWalletScreen extends StatefulWidget {
  const NewWalletScreen({super.key, required this.title});

  final String title;

  @override
  State<NewWalletScreen> createState() => _NewWalletState();
}

class _NewWalletState extends State<NewWalletScreen> {
  final double dropdownHeight = 60;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NewWalletBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => bloc.add(ChangeName(name: value)),
              decoration: const InputDecoration(hintText: AppStrings.name),
            ),
            BlocBuilder<NewWalletBloc, NewWalletState>(
                builder: (context, state) => DropdownButton<WalletType>(
                      value: state.type,
                      hint: const Text(AppStrings.type),
                      itemHeight: dropdownHeight,
                      isExpanded: true,
                      onChanged: (WalletType? value) =>
                          bloc.add(ChangeType(type: value!)),
                      items: bloc.types.map<DropdownMenuItem<WalletType>>(
                          (WalletType value) {
                        return DropdownMenuItem<WalletType>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                    )),
            BlocBuilder<NewWalletBloc, NewWalletState>(
                builder: (context, state) => DropdownButton<Bank>(
                      value: state.bank,
                      hint: const Text(AppStrings.bank),
                      itemHeight: dropdownHeight,
                      isExpanded: true,
                      onChanged: (Bank? value) =>
                          bloc.add(ChangeBank(bank: value!)),
                      items:
                          bloc.banks.map<DropdownMenuItem<Bank>>((Bank value) {
                        return DropdownMenuItem<Bank>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                    )),
            TextField(
              onChanged: (value) => bloc.add(ChangeBalance(balance: value)),
              decoration: const InputDecoration(hintText: AppStrings.balance),
              keyboardType: TextInputType.number,
            ),
            BlocBuilder<NewWalletBloc, NewWalletState>(
                builder: (context, state) => DropdownButton<Currency>(
                      value: state.currency,
                      hint: const Text(AppStrings.currency),
                      itemHeight: dropdownHeight,
                      isExpanded: true,
                      onChanged: (Currency? value) =>
                          bloc.add(ChangeCurrency(currency: value!)),
                      items: Currency.values
                          .map<DropdownMenuItem<Currency>>((Currency value) {
                        return DropdownMenuItem<Currency>(
                          value: value,
                          child: Text(value.name),
                        );
                      }).toList(),
                    )),
            const SizedBox(height: 20),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return BlocBuilder<NewWalletBloc, NewWalletState>(
                    builder: (context, state) {
                  if (state.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state.isSubmitted) {
                    submitWallet();
                    return const SizedBox.shrink();
                  }
                  if (state.error != null) {
                    showToast(state.error!);
                  }
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45)),
                      onPressed: () {
                        bloc.add(SubmitNewWallet());
                        context.read<HomeBloc>().add(FetchWallets());
                      },
                      child: const Text(AppStrings.submitBtn));
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void submitWallet() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Navigator.pop(context, true));
  }

  void showToast(String text) {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(text))));
  }
}
