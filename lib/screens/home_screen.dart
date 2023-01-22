import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/blocs/home/home_event.dart';
import 'package:savings_flutter/constants/app_strings.dart';
import 'package:savings_flutter/repositories/wallet_repository.dart';
import 'package:savings_flutter/widgets/wallet_card.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_state.dart';

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
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is HomeLoading) {
            return const CircularProgressIndicator();
          }
          if (state is HomeEmpty) {
            return const Text(AppStrings.noWallets);
          }
          if (state is HomeError) {
            return Column(mainAxisSize: MainAxisSize.min, children: [
              Text(state.errorMsg),
              ElevatedButton(
                onPressed: () {
                  fetchWallets(context);
                },
                child: const Text(AppStrings.tryAgain),
              ),
            ]);
          }
          if (state is HomeSuccess) {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: state.wallets.length,
                itemBuilder: (context, index) =>
                    WalletCard(wallet: state.wallets[index]));
          }
          if (state is HomeIdle) {
            fetchWallets(context);
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  void fetchWallets(BuildContext context) {
    context.read<HomeBloc>().add(FetchWallets());
  }
}
