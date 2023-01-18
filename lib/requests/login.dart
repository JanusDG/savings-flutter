import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO: make this work
// const loginIP =
//     String.fromEnvironment('LOGIN_IP', defaultValue: 'failed to get env');

class Resp {
  final String token;
  final String type;
  final int uid;
  final String username;

  const Resp({
    required this.token,
    required this.type,
    required this.uid,
    required this.username,
  });

  factory Resp.fromJson(Map<String, dynamic> json) {
    return Resp(
      token: json['token'],
      type: json['type'],
      uid: json['uid'],
      username: json['username'],
    );
  }
}

Future<Resp> createRespInPost(String username, String password) async {
  final response = await http.post(
    Uri.parse("http://192.168.0.104:8081/login"),
    // Uri.parse("http://$loginIP:8081/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
        <String, String>{'username': username, "password": password}),
  );

  if (response.statusCode == 200) {
    return Resp.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed');
  }
}
