import 'package:flutter/material.dart';
import 'package:savings_flutter/requests/login.dart';
import 'package:savings_flutter/constants/authconstants.dart';
import 'package:savings_flutter/screens/demoscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  Future<Resp>? futureResp;
  late String loginButtonText;

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
            _buildLoginErrorPopUp(context, LoginConstants.emptyFieldText),
      );
    }

    futureResp =
        createRespInPost(_controllerUsername.text, _controllerPassword.text);

    futureResp?.then((value) {
      loginButtonText = value.message;
      if (value.message != "") {
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              _buildLoginErrorPopUp(context, LoginConstants.invalidUserOrPass),
        );
      }
    });
  }

  Widget _buildLoginErrorPopUp(BuildContext context, String loginPopUpText) {
    return AlertDialog(
      title: const Text(LoginConstants.loginError),
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
            futureResp?.whenComplete(() {
              if (loginButtonText.isEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DemoPage(title: "Demo"),
                  ),
                );
              }
            });
          },
          child: const Text(LoginConstants.loginButtonText),
        ),
      ],
    );
  }

  FutureBuilder<Resp> futureBuilderPostPass() {
    return FutureBuilder<Resp>(
      future: futureResp,
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
