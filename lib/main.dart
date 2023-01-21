import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/repositories/wallet_repository.dart';
import 'package:savings_flutter/screens/home_screen.dart';

import 'blocs/home/home_bloc.dart';

void main() {
  runApp(const SavingsApp());
}

class SavingsApp extends StatelessWidget {
  const SavingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider(
          create: (context) => HomeBloc(WalletRepository()),
          child: HomeScreen(),
        ));
  }
}
