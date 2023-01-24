import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/constants/app_strings.dart';
import 'package:savings_flutter/models/login.dart';

import '../blocs/home/home_bloc.dart';
import '../repositories/login_repository.dart';
import '../repositories/transaction_reporitory.dart';
import '../repositories/wallet_repository.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  Future<LoginResp>? futureLoginResp;
  late String loginButtonText;
  late int uid;

  final TextEditingController _controllerUsername =
      TextEditingController(text: "");
  final TextEditingController _controllerPassword =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: buildLoginFields(),
          ),
        ));
  }

  void validateLogin() {
    if (_controllerPassword.text.isEmpty || _controllerUsername.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            _buildLoginErrorPopUp(context, AppStrings.emptyFieldText),
      );
      return;
    }

    futureLoginResp =
        getLoginResponce(_controllerUsername.text, _controllerPassword.text);

    futureLoginResp?.then((value) {
      loginButtonText = value.message;
      uid = value.uid;
      if (value.message != "") {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildLoginErrorPopUp(context, AppStrings.invalidUserOrPass),
        );
      }
    });
  }

  Widget _buildLoginErrorPopUp(BuildContext context, String loginPopUpText) {
    return AlertDialog(
      title: const Text(AppStrings.loginError),
      content: Text(loginPopUpText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        ),
      ],
    );
  }

  Column buildLoginFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _controllerUsername,
          decoration: const InputDecoration(hintText: 'Enter username'),
        ),
        TextFormField(
            controller: _controllerPassword,
            decoration: const InputDecoration(hintText: 'Enter password'),
            obscureText: true),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              validateLogin();
            });
            futureLoginResp?.whenComplete(() {
              if (loginButtonText.isEmpty) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider(
                        create: (context) => HomeBloc(
                            WalletRepository(), TransactionRepository(), uid),
                        child: const HomeScreen(title: AppStrings.appName),
                      );
                    },
                  ),
                );
              }
            });
          },
          child: const Text(AppStrings.loginButtonText),
        ),
      ],
    );
  }
}
