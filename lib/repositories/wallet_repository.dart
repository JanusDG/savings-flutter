import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/wallet.dart';
import '../models/wallet_type.dart';

const loginIP = String.fromEnvironment('LOGIN_IP', defaultValue: 'failed to get env');
const baseUrl = 'http://$loginIP:8070/api';

class WalletRepository {
  Future<List<Wallet>> fetchWallets(int uid, List<WalletType> types) async {
    final response = await http.get(Uri.parse("$baseUrl/wallets/$uid"));
    if (response.statusCode == 200) {
      List<Wallet> wallets = (jsonDecode(response.body)['wallets'] as List)
          .map((data) => Wallet.fromJson(data, types)).toList();
      return wallets;
    } else {
      throw Exception('Failed to fetch wallets');
    }
  }

  Future<List<WalletType>> fetchWalletTypes() async {
    final response = await http.get(Uri.parse("$baseUrl/wallet-type"));
    if (response.statusCode == 200) {
      List<WalletType> types = (jsonDecode(response.body) as List)
          .map((data) => WalletType.fromJson(data)).toList();
      return types;
    } else {
      throw Exception('Failed to fetch wallet types');
    }
  }
}
