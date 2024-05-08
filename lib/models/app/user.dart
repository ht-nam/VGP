class User {
  User({this.id, required this.name, required this.accountType,});

  int? id;
  String name;
  String accountType;

  User.fromJson(Map<String, dynamic> json) :
        id = json["id"],
        name = json["name"],
        accountType = json["account_type"];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'account_type': accountType,
  };
}