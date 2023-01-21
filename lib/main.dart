import 'package:flutter/material.dart';
import 'package:savings_flutter/screens/loginscreen.dart';

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
        home: const LoginScreen(title: 'Flutter Demo Home Page'));
  }
}
