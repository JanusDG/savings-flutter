import 'package:savings_flutter/models/wallet_type.dart';

class Wallet {
  int? id;
  int? typeId;
  String typeName = '';
  int? userId;
  String name = '';
  int balance = 0;
  String currency = '';
  int? bankId;
  String bankName = '';
  String bankImg = 'logo.png';

  Wallet.fromJson(Map<String, dynamic> json, List<WalletType> types) {
    id = json['id'];
    typeId = json['s_id'];
    typeName = types.firstWhere((type) => type.id == json['s_id']).name;
    userId = json['s_uid'];
    name = json['s_name'];
    balance = json['s_balance'];
    currency = json['s_currency'];
    bankId = json['b_id'];
    bankName = json['b_name'];
    bankImg = json['b_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['s_id'] = typeId;
    data['s_uid'] = userId;
    data['s_name'] = name;
    data['s_balance'] = balance;
    data['s_currency'] = currency;
    data['b_id'] = bankId;
    data['b_name'] = bankName;
    data['b_img'] = bankImg;
    return data;
  }
}
