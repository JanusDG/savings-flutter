import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_state.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import '../widgets/transaction_feed.dart';
import 'package:pie_chart/pie_chart.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key, required this.wallet});

  final Wallet wallet;
  // final List<Transaction> transactions;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        List<Transaction> walletTransactions = [];
        if (state is HomeSuccess) {
          walletTransactions = state.transactions
              .where(((element) => element.walletid == wallet.id))
              .toList();
        }
        Map<String, double> dataMap = {};
        for (var element in walletTransactions) {
          dataMap.update(element.description, (list) => list + element.delta,
              ifAbsent: () => element.delta.toDouble());
        }

        return Scaffold(
            appBar: AppBar(
              title: Text(wallet.name),
            ),
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                // Text(""),
                Container(
                  padding: const EdgeInsets.all(16),
                  height: 150,
                  child: Row(
                    children: [
                      Image.asset("assets/images/${wallet.bankImg}"),
                      const SizedBox(width: 60),
                      Container(
                        padding: const EdgeInsets.all(39),
                        child: Column(
                          children: [
                            const Text("Balance:"),
                            Text(
                              "${wallet.balance} ${wallet.currency}",
                              style: TextStyle(
                                  color: wallet.balance > 0
                                      ? Colors.green.withOpacity(0.8)
                                      : Colors.red.withOpacity(0.8),
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                PieChart(
                  dataMap: dataMap,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  legendOptions: const LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    // legendShape: ci
                    legendTextStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        // fontStyle: FontStyle()
                        fontSize: 10),
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: walletTransactions.length,
                      itemBuilder: (context, index) {
                        return TransactionFeed(
                            transaction: walletTransactions[index],
                            ownerWallet: wallet);
                      }),
                ),
              ],
            ));
      },
    );
  }
}
