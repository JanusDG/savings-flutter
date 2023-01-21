const loginIP =
    String.fromEnvironment('LOGIN_IP', defaultValue: 'failed to get env');

class LoginResp {
  final String token;
  final String type;
  final int uid;
  final String username;
  final String message;

  LoginResp({
    required this.message,
    required this.token,
    required this.type,
    required this.uid,
    required this.username,
  });

  factory LoginResp.tokenResponce(Map<String, dynamic> json) {
    return LoginResp(
      message: "",
      token: json['token'],
      type: json['type'],
      uid: json['uid'],
      username: json['username'],
    );
  }

  factory LoginResp.errorResponce(Map<String, dynamic> json) {
    return LoginResp(
      message: json['message'],
      token: "",
      type: "",
      uid: -1,
      username: "",
    );
  }
}
