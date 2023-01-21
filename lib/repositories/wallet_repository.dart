import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/wallet.dart';

const loginIP = String.fromEnvironment('LOGIN_IP', defaultValue: 'failed to get env');

class WalletRepository {
  Future<List<Wallet>> fetchWallets(int uid) async {
    final response = await http.get(
      Uri.parse("http://$loginIP:8070/api/wallets/$uid"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<Wallet> wallets = (jsonDecode(response.body)['wallets'] as List)
          .map((data) => Wallet.fromJson(data)).toList();
      return wallets;
    } else {
      throw Exception('Failed to fetch wallets');
    }
  }
}
