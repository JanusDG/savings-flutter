class WalletType {
  int? id;
  String name = '';

  WalletType.fromJson(Map<String, dynamic> json) {
    id = json['s_id'];
    name = json['s_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['s_id'] = id;
    data['s_name'] = name;
    return data;
  }
}
