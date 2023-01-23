class WalletType {
  int? id;
  String name = '';

  WalletType.fromJson(Map<String, dynamic> json) {
    id = json['s_id'];
    name = json['s_name'];
  }
}
