import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/login.dart';

Future<LoginResp> getLoginResponce(String username, String password) async {
  if (loginIP == "failed to get env") {
    throw Exception('Failed');
  }
  final response = await http.post(
    Uri.parse("http://$loginIP:8081/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': username, "password": password}),
  );

  if (response.statusCode == 200) {
    return LoginResp.tokenResponce(jsonDecode(response.body));
  } else {
    try {
      return LoginResp.errorResponce(jsonDecode(response.body));
    } catch (e) {
      return LoginResp(
        message: "Invalid username",
        token: "",
        type: "",
        uid: -1,
        username: "",
      );
    }
  }
}
