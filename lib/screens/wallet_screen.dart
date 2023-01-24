import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_state.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/wallet.dart';
import '../widgets/transaction_feed.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key, required this.wallet});

  final Wallet wallet;

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
        final categories = context.read<HomeBloc>().categories;
        Map<String, double> incomeMap = {};
        Map<String, double> outcomeMap = {};
        for (var transaction in walletTransactions) {
          Category category = categories
              .firstWhere((element) => element.id == transaction.categoryid);
          if (category.isIncome) {
            incomeMap.update(
                category.name, (list) => list + (transaction.delta / 10),
                ifAbsent: () => transaction.delta.toDouble() / 10);
          } else {
            outcomeMap.update(
                category.name, (list) => list + (transaction.delta / 10),
                ifAbsent: () => transaction.delta.toDouble() / 10);
          }
        }

        return Scaffold(
            appBar: AppBar(
              title: Text(wallet.name),
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    height: 100,
                    child: Row(
                      children: [
                        Image.asset("assets/images/${wallet.bankImg}"),
                        const SizedBox(width: 16),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bank: ${wallet.bankName}"),
                            Text("Type: ${wallet.typeName}"),
                            Row(
                              children: [
                                const Text("Balance: "),
                                Text(
                                  "${wallet.balance / 10} ${wallet.currency}",
                                  style: TextStyle(
                                      color: wallet.balance > 0
                                          ? Colors.green.withOpacity(0.8)
                                          : Colors.red.withOpacity(0.8),
                                      fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      incomeMap.isNotEmpty
                          ? getPlotFromMap(context, "Income", incomeMap)
                          : const SizedBox.shrink(),
                      outcomeMap.isNotEmpty
                          ? getPlotFromMap(context, "Outcome", outcomeMap)
                          : const SizedBox.shrink(),
                    ],
                  ),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: walletTransactions.length,
                      itemBuilder: (context, index) {
                        return TransactionFeed(
                            transaction: walletTransactions[index],
                            ownerWallet: wallet);
                      }),
                ],
              ),
            ));
      },
    );
  }

  Column getPlotFromMap(
          BuildContext context, String plotName, Map<String, double> dataMap) =>
      Column(
        children: [
          Text(plotName, style: const TextStyle(fontWeight: FontWeight.bold)),
          PieChart(
            dataMap: dataMap,
            chartRadius: MediaQuery.of(context).size.width / 3.2,
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.bottom,
              showLegends: true,
              // legendShape: ci
              legendTextStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  // fontStyle: FontStyle()
                  fontSize: 10),
            ),
          ),
        ],
      );
}
