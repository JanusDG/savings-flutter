import 'package:flutter/material.dart';
import 'package:savings_flutter/models/wallet.dart';

import '../models/transaction.dart';

class TransactionFeed extends StatelessWidget {
  const TransactionFeed(
      {super.key, required this.transaction, required this.ownerWallet});

  final Wallet ownerWallet;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) => Card(
          child: Container(
        height: 80,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Image.asset("assets/images/logo.png"),
              Column(
                children: [
                  const Text("Wallet",
                      style: TextStyle(fontSize: 8, color: Colors.black38)),
                  Text(ownerWallet.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              )
            ]),
            Column(
              children: [
                const Text("Amount: ",
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.black38,
                    )),
                Text(
                  "${transaction.delta / 10} ${ownerWallet.currency}",
                  style: TextStyle(
                      color: transaction.delta > 0
                          ? Colors.green.withOpacity(0.8)
                          : Colors.red.withOpacity(0.8),
                      fontSize: 14),
                ),
                Text(
                  transaction.datetime.split(' ')[0],
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ));
}
