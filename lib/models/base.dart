class Base {
  int? id;

  Base({this.id});

  Base.fromJson(Map<String, dynamic> json) : id = json["id"];

  Map<String, dynamic> toJson() => {'id': id};

  @override
  String toString() => "$id";
}
