import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/screens/wallet_screen.dart';

import '../blocs/home/home_bloc.dart';
import '../models/wallet.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({super.key, required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Card(
            child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (newContext) {
              return BlocProvider.value(
                value: BlocProvider.of<HomeBloc>(context),
                child: WalletScreen(wallet: wallet),
              );
            }));
          },
          child: Container(
              height: 100,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Image.asset("assets/images/${wallet.bankImg}"),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(wallet.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("${wallet.bankName} - ${wallet.typeName}")
                    ],
                  ),
                  const Spacer(),
                  Text("${wallet.balance / 10} ${wallet.currency}")
                ],
              )),
        )),
      );
}
