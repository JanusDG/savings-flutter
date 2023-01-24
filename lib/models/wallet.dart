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

  Wallet(
      {this.id,
      this.typeId,
      this.userId,
      required this.name,
      required this.balance,
      required this.currency,
      this.bankId});

  Wallet.fromJson(Map<String, dynamic> json, List<WalletType> types) {
    id = json['s_id'];
    typeId = json['id'];
    typeName = types.firstWhere((type) => type.id == json['id']).name;
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
    data['s_id'] = id.toString();
    data['id'] = typeId.toString();
    data['s_uid'] = userId.toString();
    data['s_name'] = name;
    data['s_balance'] = balance.toString();
    data['s_currency'] = currency;
    data['b_id'] = bankId.toString();
    return data;
  }
}
