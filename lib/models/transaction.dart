// w_id
// c_id
// t_delta
// t_description

// curl -X POST  192.168.0.104:8070/api/transaction/add  -H 'Content-Type: application/json' -d '{"w_id": "1", "c_id": "1", "t_delta":"1", "t_description":"test"}'

import 'dart:collection';

class Transaction {
  int? tid;
  int? walletid;
  int? categoryid;
  int delta = 0;
  String datetime = '';
  String description = '';

  Transaction.fromJson(Map<String, dynamic> json) {
    tid = json['t_id'];
    walletid = json['w_id'];
    categoryid = json['c_id'];
    delta = json['t_delta'];
    description = json['t_description'];
    var hashMap = HashMap.from(json['t_datetime']
        .map((key, value) => MapEntry(key.toString(), value.toString())));
    datetime = hashMap["date"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['t_id'] = tid;
    data['w_id'] = walletid;
    data['c_id'] = categoryid;
    data['t_delta'] = delta;
    data['t_description'] = description;
    data['t_datetime'] = datetime;

    return data;
  }
}

// class TranactionCreateResp {
//   final String token;
//   final String type;
//   final int uid;
//   final String username;
//   final String message;

//   TranactionCreateResp({
//     required this.message,
//     required this.token,
//     required this.type,
//     required this.uid,
//     required this.username,
//   });

//   factory TranactionCreateResp.tokenResponce(Map<String, dynamic> json) {
//     return TranactionCreateResp(
//       message: "",
//       token: json['token'],
//       type: json['type'],
//       uid: json['uid'],
//       username: json['username'],
//     );
//   }

//   factory TranactionCreateResp.errorResponce(Map<String, dynamic> json) {
//     return TranactionCreateResp(
//       message: json['message'],
//       token: "",
//       type: "",
//       uid: -1,
//       username: "",
//     );
//   }
// }
