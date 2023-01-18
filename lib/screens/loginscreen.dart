import 'package:flutter/material.dart';
import 'package:savings_flutter/requests/login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _SavingsAppState();
}

// const loginIP =
//     String.fromEnvironment('LOGIN_IP', defaultValue: 'failed to get env');

class _SavingsAppState extends State<LoginScreen> {
  Future<Resp>? futureResp;

  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

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
          buildColumnDouble(),
          futureBuilderPostPass(),
        ],
      )),
    );
  }

  Column buildColumnDouble() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controllerUsername,
          decoration: const InputDecoration(hintText: 'Enter username'),
        ),
        TextField(
          controller: _controllerPassword,
          decoration: const InputDecoration(hintText: 'Enter password'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              futureResp = createRespInPost(
                  _controllerUsername.text, _controllerPassword.text);
            });
          },
          child: const Text('Create Data'),
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
