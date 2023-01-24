import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/blocs/home/home_event.dart';
import 'package:savings_flutter/blocs/new_wallet/new_wallet_bloc.dart';
import 'package:savings_flutter/constants/app_strings.dart';
import 'package:savings_flutter/models/wallet.dart';
import 'package:savings_flutter/repositories/wallet_repository.dart';
import 'package:savings_flutter/screens/new_wallet_screen.dart';
import 'package:savings_flutter/widgets/wallet_card.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_state.dart';
import '../widgets/new_transaction_popUp.dart';
import '../widgets/transaction_feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final WalletRepository repository = WalletRepository();

  // final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToNewWalletScreen(),
        child: const Icon(Icons.wallet),
      ),
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
                      fetchWallets();
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

              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  void fetchWallets() {
    context.read<HomeBloc>().add(FetchWallets());
  }

  void navigateToNewWalletScreen() {
    final bloc = context.read<HomeBloc>();
    if (bloc.state is HomeSuccess) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return BlocProvider(
              create: (context) => NewWalletBloc(
                  bloc.walletRepository, bloc.uid, bloc.types, bloc.banks),
              child: const NewWalletScreen(title: AppStrings.newWalletScreen),
            );
          },
        ),
      );
    }
  }

// void fetchTransactions(BuildContext context) {
//   context.read<HomeBloc>().add(FetchTransactions());
// }
}
