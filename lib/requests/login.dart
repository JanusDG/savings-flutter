import 'dart:convert';
import 'package:http/http.dart' as http;

const loginIP =
    String.fromEnvironment('LOGIN_IP', defaultValue: 'failed to get env');

class Resp {
  final String token;
  final String type;
  final int uid;
  final String username;
  final String message;

  Resp({
    required this.message,
    required this.token,
    required this.type,
    required this.uid,
    required this.username,
  });

  factory Resp.tokenResponce(Map<String, dynamic> json) {
    return Resp(
      message: "",
      token: json['token'],
      type: json['type'],
      uid: json['uid'],
      username: json['username'],
    );
  }

  factory Resp.errorResponce(Map<String, dynamic> json) {
    return Resp(
      message: json['message'],
      token: "",
      type: "",
      uid: -1,
      username: "",
    );
  }
}

Future<Resp> createRespInPost(String username, String password) async {
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
    return Resp.tokenResponce(jsonDecode(response.body));
  } else {
    try {
      return Resp.errorResponce(jsonDecode(response.body));
    } catch (e) {
      return Resp(
        message: "Invalid username",
        token: "",
        type: "",
        uid: -1,
        username: "",
      );
    }
  }
}
