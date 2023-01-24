class Category {
  int? id;
  String name = '';
  bool isIncome = false;

  Category.fromJson(Map<String, dynamic> json) {
    id = json['c_id'];
    name = json['c_name'];
    isIncome = json['c_income'] == 1;
  }
}
