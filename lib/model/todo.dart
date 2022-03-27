class Todo {
  final dynamic id;
  final dynamic taskId;
  final dynamic title;
  final dynamic isDone;
  Todo({this.id, this.taskId, this.title, this.isDone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isDone': isDone,
    };
  }
}
