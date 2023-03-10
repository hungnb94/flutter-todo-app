import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/data/todo_database.dart';
import 'package:todo_app/screens/details/details_arguments.dart';
import 'package:todo_app/screens/details/details_result.dart';
import 'package:todo_app/widgets/todo_item.dart';

import '../generated/l10n.dart';
import '../model/todo.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoList = <ToDo>[];
  var foundTodos = <ToDo>[];

  final _todoController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void _onItemDeleted(ToDo todo) {
    TodoDatabase.instance.delete(todo.id!);
    var snackBar = SnackBar(
      content: Text(S.of(context).itemHasBeenDeleted),
      action: SnackBarAction(
        label: S.of(context).undo,
        onPressed: () {
          TodoDatabase.instance.recover(todo.id!);
          refreshList();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    refreshList();
  }

  void _onItemChanged(ToDo todo) {
    todo.isDone = !todo.isDone;
    TodoDatabase.instance.update(todo);
    refreshList();
  }

  Future<void> _onItemClicked(ToDo todo) async {
    final result = await Navigator.pushNamed(context, '/details',
        arguments: DetailsArguments(todo));
    if (!mounted || result == null) return;

    if (result is DetailsResult) {
      if (result.isEdited()) {
        TodoDatabase.instance.update(result.todo);
        refreshList();
      } else if (result.isDeleted()) {
        _onItemDeleted(todo);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              _searchBox(),
              Expanded(
                child: GridView.count(
                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2,
                  childAspectRatio: 5,
                  children: [
                    _textAllTodos(),
                    for (ToDo item in foundTodos.reversed)
                      ToDoItem(
                        todo: item,
                        onItemClicked: _onItemClicked,
                        onItemChanged: _onItemChanged,
                        onItemDeleted: _onItemDeleted,
                      )
                  ],
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  margin:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: InputDecoration(
                      hintText: S.of(context).addANewTodoItem,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  right: 20,
                  bottom: 20,
                ),
                child: ElevatedButton(
                  onPressed: _addToDoItem,
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdBlue,
                    minimumSize: const Size(60, 60),
                    elevation: 10,
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }

  buildAppBar() {
    return AppBar(
      elevation: 0,
      title: Row(
        children: const [
          Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filter,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
            color: tdBlack,
          ),
          prefixIconConstraints:
              const BoxConstraints(maxHeight: 20, minWidth: 25),
          border: InputBorder.none,
          hintText: S.of(context).search,
          hintStyle: const TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  void _addToDoItem() {
    var text = _todoController.text.trim();
    if (text.isNotEmpty) {
      var todo = ToDo(id: DateTime.now().millisecond.toString(), text: text);
      TodoDatabase.instance.insert(todo);
      _todoController.clear();
      refreshList();
    }
  }

  void _filter(String keyword) {
    var condition = keyword.toLowerCase();
    List<ToDo> result;
    if (condition.isNotEmpty) {
      result = todoList
          .where((element) => element.text.toLowerCase().contains(condition))
          .toList();
    } else {
      result = todoList;
    }
    setState(() {
      foundTodos = result;
    });
  }

  void refreshList() async {
    var todos = await TodoDatabase.instance.getTodos();
    todoList.clear();
    todoList.addAll(todos);
    _filter(_searchController.text);
  }

  Widget _textAllTodos() {
    return Container(
        margin: const EdgeInsets.only(
          top: 25,
          bottom: 20,
        ),
        child: Text(
          S.of(context).allTodos,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
  }
}
