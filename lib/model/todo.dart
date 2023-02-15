class ToDo {
  String? id;
  String text;
  bool isDone;

  ToDo({
    required this.id,
    required this.text,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '1', text: 'Morning Exercise', isDone: true),
      ToDo(id: '2', text: 'Buy Groceries', isDone: true),
      ToDo(id: '3', text: 'Check Mail', isDone: false),
      ToDo(id: '4', text: 'Team Meeting', isDone: false),
      ToDo(id: '5', text: 'Dinner with Tam', isDone: false),
      ToDo(id: '5', text: 'Work on mobile app for 2 hours', isDone: false),
    ];
  }
}
