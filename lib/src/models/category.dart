class Categories {
  int id;
  String name;
  String description;

  Categories({this.id, this.name, this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
