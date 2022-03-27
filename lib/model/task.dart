class Task {
  final dynamic id;
  final String? title;
  final String? description;
  Task({this.title, this.id, this.description});
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'description': description};
  }
}
