import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:savings_flutter/models/transaction.dart';

import '../models/category.dart';

const loginIP =
    String.fromEnvironment('LOGIN_IP', defaultValue: 'failed to get env');

class TransactionRepository {
  Future<List<Transaction>> fetchUserTransactions(List<int> walletsIds) async {
    List<Transaction> userTransactions = [];
    for (var wId in walletsIds) {
      userTransactions.addAll(await fetchWalletTransactions(wId));
    }
    return userTransactions;
  }

  Future<List<Transaction>> fetchWalletTransactions(int wid) async {
    final responseTransactions = await http.get(
      Uri.parse("http://$loginIP:8070/api/transactions/$wid"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (responseTransactions.statusCode == 200) {
      List<Transaction> transactions =
          (jsonDecode(responseTransactions.body)['transactions'] as List)
              .map((data) => Transaction.fromJson(data))
              .toList();
      return transactions;
    } else {
      throw Exception('Failed to fetch Transactions');
    }
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse("http://$loginIP:8070/api/categories/all"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<Category> categories =
          (jsonDecode(response.body)['categories'] as List)
              .map((data) => Category.fromJson(data))
              .toList();
      return categories;
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
}

Future<dynamic> getTranactionCreateResponce(
    String wid, String cid, String delta, String description) async {
  if (loginIP == "failed to get env") {
    throw Exception('Failed');
  }

  var map = <String, dynamic>{};
  map['w_id'] = wid;
  map['c_id'] = cid;
  map['t_delta'] = delta;
  map['t_description'] = description;

  final response = await http.post(
    Uri.parse('http://$loginIP:8070/api/transaction/add'),
    body: map,
  );

  if (response.statusCode == 202) {
    return jsonDecode(response.body);
  } else {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      return e;
    }
  }
}
