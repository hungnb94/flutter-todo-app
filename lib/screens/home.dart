import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/data/todo_database.dart';
import 'package:todo_app/screens/details/details_arguments.dart';
import 'package:todo_app/screens/details/details_result.dart';
import 'package:todo_app/widgets/button_add.dart';
import 'package:todo_app/widgets/list_data.dart';
import 'package:todo_app/widgets/search_box.dart';
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
  final GlobalKey<AnimatedGridState> _animatedKey =
      GlobalKey<AnimatedGridState>();
  late ListModel<ToDo> foundTodos;

  final _todoController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    foundTodos =
        ListModel(listKey: _animatedKey, removedItemBuilder: _buildRemovedItem);
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
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
          child: Column(
            children: [
              SearchBox(controller: _searchController, onChanged: _filter),
              Expanded(
                child: AnimatedGrid(
                  padding: const EdgeInsets.only(top: 25, bottom: 20),
                  key: _animatedKey,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 1
                        : 2,
                    childAspectRatio: 5,
                  ),
                  initialItemCount: foundTodos.length,
                  itemBuilder: _buildItem,
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
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black,
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
              ButtonAdd(
                onPressed: _addToDoItem,
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

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    var todo = foundTodos[index];
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.bounceOut,
      ),
      child: ToDoItem(
          todo: todo,
          onItemClicked: _onItemClicked,
          onItemChanged: _onItemChanged,
          onItemDeleted: _onItemDeleted),
    );
  }

  Widget _buildRemovedItem(
      ToDo item, BuildContext context, Animation<double> animation) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ),
      child: ToDoItem(
          todo: item,
          onItemClicked: _onItemClicked,
          onItemChanged: _onItemChanged,
          onItemDeleted: _onItemDeleted),
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
    updateList(result.reversed.toList());
  }

  void updateList(List<ToDo> newList) {
    var i = 0, j = 0;
    while (i < foundTodos.length && j < newList.length) {
      var first = foundTodos[i];
      var second = newList[j];
      if (first.id == second.id) {
        foundTodos[i] = second;
        i++;
        j++;
      } else if ((newList.indexWhere((element) => element.id == first.id, j)) >=
          0) {
        foundTodos.insert(i, second);
        i++;
        j++;
      } else {
        foundTodos.removeAt(i);
      }
    }
    while (i < foundTodos.length) {
      foundTodos.removeAt(i);
    }
    while (j < newList.length) {
      foundTodos.insert(j, newList[j++]);
    }
    setState(() {
      foundTodos;
    });
  }

  void refreshList() async {
    var todos = await TodoDatabase.instance.getTodos();
    todoList.clear();
    todoList.addAll(todos);
    _filter(_searchController.text);
  }
}
