class Bank {
  int? id;
  String name = '';
  String img = 'logo.png';

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['s_id'];
    name = json['s_name'];
    img = json['s_img'];
  }
}
