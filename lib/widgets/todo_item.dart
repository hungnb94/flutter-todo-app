import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';

import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onItemChanged;
  final onItemDeleted;
  final onItemClicked;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onItemClicked,
    required this.onItemChanged,
    required this.onItemDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      child: ListTile(
        onTap: () {
          onItemClicked(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        tileColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        leading: IconButton(
          icon: Icon(
            todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
            color: tdBlue,
          ),
          onPressed: () {
            onItemChanged(todo);
          },
        ),
        title: Text(
          todo.text,
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light ? tdBlack : tdGrey,
            fontSize: 16,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: tdRed,
          ),
          child: IconButton(
            iconSize: 18,
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              onItemDeleted(todo);
            },
          ),
        ),
      ),
    );
  }
}
