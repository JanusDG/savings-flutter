import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/bank.dart';
import '../models/wallet.dart';
import '../models/wallet_type.dart';

const loginIP = '192.168.0.110';
//const loginIP = String.fromEnvironment('LOGIN_IP', defaultValue: 'failed to get env');
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
      if (types.isEmpty) {
        throw Exception('No wallet types in database');
      }
      return types;
    } else {
      throw Exception('Failed to fetch wallet types');
    }
  }

  Future<List<Bank>> fetchBanks() async {
    final response = await http.get(Uri.parse("$baseUrl/banks"));
    if (response.statusCode == 200) {
      List<Bank> banks = (jsonDecode(response.body) as List)
          .map((data) => Bank.fromJson(data)).toList();
      if (banks.isEmpty) {
        throw Exception('No banks in database');
      }
      return banks;
    } else {
      throw Exception('Failed to fetch banks');
    }
  }
}
