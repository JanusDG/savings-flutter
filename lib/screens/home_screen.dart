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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is HomeIdle) {
            fetchWallets();
          }
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeEmpty) {
            return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text(AppStrings.noWallets),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => navigateToNewWalletScreen(context),
                child: const Text('Add wallet'),
              ),
            ]));
          }
          if (state is HomeError) {
            return Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Error: ${state.errorMsg}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  fetchWallets();
                },
                child: const Text('Try again'),
              ),
            ]));
          }
          if (state is HomeSuccess) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Wallets",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () => navigateToNewWalletScreen(context),
                        child: const Icon(Icons.add),
                      )
                    ],
                  ),
                  BlocProvider.value(
                      value: BlocProvider.of<HomeBloc>(context),
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: state.wallets.length,
                          itemBuilder: (context, index) =>
                              WalletCard(wallet: state.wallets[index]))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Transactions",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      BlocProvider.value(
                        value: BlocProvider.of<HomeBloc>(context),
                        child: NewTransactionPopUp(),
                      ),
                    ],
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
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
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        }),
      ),
    );
  }

  void fetchWallets() {
    context.read<HomeBloc>().add(FetchWallets());
  }

  void navigateToNewWalletScreen(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (newContext) {
          return BlocProvider.value(
            value: BlocProvider.of<HomeBloc>(context),
            child: BlocProvider(
              create: (context) => NewWalletBloc(
                  bloc.walletRepository, bloc.uid, bloc.types, bloc.banks),
              child: const NewWalletScreen(title: AppStrings.newWalletScreen),
            ),
          );
        },
      ),
    );
  }
}
