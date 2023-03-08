import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/todo.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();

  /// The database when opened.
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _openDb(await getDatabasesPath() + '/notes.db');
    return _database!;
  }

  TodoDatabase._init();

  /// Open the database.
  Future _openDb(String path) async {
    var database = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
create table $tableTodo(
  $columnId text primary key not null,
  $columnTitle text not null,
  $columnDone integer not null)
''');
        await db.transaction((txn) async {
          var list = ToDo.todoList();
          for (var todo in list) {
            await txn.insert(tableTodo, todo.toMap());
          }
        });
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        var batch = db.batch();
        if (oldVersion < 2) {
          _updateTableTodoV1ToV2(batch);
        }
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
    return database;
  }

  /// Insert a to-do.
  Future<ToDo> insert(ToDo todo) async {
    var db = await database;
    await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  /// Get a to-do.
  Future<List<ToDo>> getTodos() async {
    var db = await database;
    final List<Map> maps = await db.query(
      tableTodo,
      columns: [columnId, columnDone, columnTitle],
      where: '$columnDeleted = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (index) => ToDo.fromMap(maps[index]));
  }

  /// Get a to-do.
  Future<ToDo?> getTodo(int id) async {
    var db = await database;
    final List<Map> maps = await db.query(tableTodo,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ToDo.fromMap(maps.first);
    }
    return null;
  }

  /// Delete a to-do.
  Future<int> delete(String id) async {
    var db = await database;
    return await db.update(
        tableTodo,
        {
          columnId: id,
          columnDeleted: 1,
        },
        where: '$columnId = ?',
        whereArgs: [id]);
  }

  /// Recover a to-do
  Future<int> recover(String id) async {
    var db = await database;
    return await db.update(
        tableTodo,
        {
          columnId: id,
          columnDeleted: 0,
        },
        where: '$columnId = ?',
        whereArgs: [id]);
  }

  /// Update a to-do.
  Future<int> update(ToDo todo) async {
    var db = await database;
    return await db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id!]);
  }

  /// Close database.
  Future close() async {
    var db = await database;
    await db.close();
  }

  void _updateTableTodoV1ToV2(Batch batch) {
    batch.execute(
        'alter table $tableTodo add column $columnDeleted integer not null default 0');
  }
}
