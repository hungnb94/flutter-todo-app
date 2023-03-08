/// `to-do` table name
const String tableTodo = 'todo';

/// id column name
const String columnId = '_id';

/// title column name
const String columnTitle = 'title';

/// done column name
const String columnDone = 'done';

/// deleted column name
const String columnDeleted = 'deleted';

class ToDo {
  String? id;
  String text;
  bool isDone;
  bool deleted;

  ToDo({
    required this.id,
    required this.text,
    this.isDone = false,
    this.deleted = false,
  });

  ToDo copy({String? id, String? text, bool? isDone, bool? deleted}) {
    return ToDo(
      id: id ?? this.id,
      text: text ?? this.text,
      isDone: isDone ?? this.isDone,
      deleted: deleted ?? this.deleted,
    );
  }

  static List<ToDo> todoList() {
    return [
      ToDo(id: '1', text: 'Morning Exercise', isDone: true),
      ToDo(id: '2', text: 'Buy Groceries', isDone: true),
      ToDo(id: '3', text: 'Check Mail', isDone: false),
      ToDo(id: '4', text: 'Team Meeting', isDone: false),
      ToDo(id: '5', text: 'Dinner with Tam', isDone: false),
      ToDo(id: '6', text: 'Work on mobile app for 2 hours', isDone: false),
    ];
  }

  static ToDo fromMap(Map map) {
    return ToDo(
      id: map[columnId],
      text: map[columnTitle],
      isDone: map[columnDone] == 1,
      deleted: map[columnDeleted] == 1
    );
  }

  Map<String, Object?> toMap() {
    final map = <String, Object?>{
      columnTitle: text,
      columnDone: isDone ? 1 : 0,
      columnDeleted: deleted ? 1 : 0,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}
