import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_flutter/models/login.dart';
import 'package:savings_flutter/constants/app_strings.dart';

import '../blocs/home/home_bloc.dart';
import '../repositories/wallet_repository.dart';
import '../repositories/login_repository.dart';
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

  // ignore: todo
  // TODO remove initial value after developement is finished
  final TextEditingController _controllerUsername =
      TextEditingController(text: "demo");
  final TextEditingController _controllerPassword =
      TextEditingController(text: "demo");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildLoginFields(),
          futureBuilderPostPass(),
        ],
      )),
    );
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
        ),
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
                        create: (context) => HomeBloc(WalletRepository(), uid),
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

  FutureBuilder<LoginResp> futureBuilderPostPass() {
    return FutureBuilder<LoginResp>(
      future: futureLoginResp,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text('token = ${snapshot.data!.token}'),
              Text('type = ${snapshot.data!.type}'),
              Text('uid = ${snapshot.data!.uid}'),
              Text('username = ${snapshot.data!.username}'),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
