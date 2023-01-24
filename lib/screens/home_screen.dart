import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/blocs/home/home_event.dart';
import 'package:savings_flutter/models/wallet.dart';
import 'package:savings_flutter/repositories/wallet_repository.dart';
import 'package:savings_flutter/widgets/wallet_card.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_state.dart';
import '../widgets/new_transaction_popUp.dart';
import '../widgets/transaction_feed.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final WalletRepository repository = WalletRepository();

  // final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
              if (state is HomeLoading) {
                return const CircularProgressIndicator();
              }
              if (state is HomeError) {
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('Error: ${state.errorMsg}'),
                  ElevatedButton(
                    onPressed: () {
                      fetchWallets(context);
                    },
                    child: const Text('Try again'),
                  ),
                ]);
              }
              if (state is HomeSuccess) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 80),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: state.wallets.length,
                          itemBuilder: (context, index) =>
                              WalletCard(wallet: state.wallets[index])),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Text("Transactions",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 215),
                        BlocProvider.value(
                          value: BlocProvider.of<HomeBloc>(context),
                          child: NewTransactionPopUp(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 450,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: state.transactions.length,
                          itemBuilder: (context, index) {
                            List<Wallet> wallet = state.wallets
                                .where(((element) =>
                                    element.id ==
                                    state.transactions[index].walletid))
                                .toList();

                            return TransactionFeed(
                                transaction: state.transactions[index],
                                ownerWallet: wallet[0]);
                          }),
                    ),
                  ],
                );
              }
              fetchWallets(context);
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  void fetchWallets(BuildContext context) {
    context.read<HomeBloc>().add(FetchWallets());
  }

  // void fetchTransactions(BuildContext context) {
  //   context.read<HomeBloc>().add(FetchTransactions());
  // }
}
