class Note {
  int id;
  String title;
  String description;
  String date;
  String category;
  int isFinished;

  Note({this.id, this.title, this.description, this.category, this.isFinished});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'category': category,
      'isFinished': isFinished,
    };
  }
}
