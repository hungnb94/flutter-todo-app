import 'package:flutter/material.dart';
import 'package:todo_app/screens/details/details_arguments.dart';
import 'package:todo_app/screens/details/details_result.dart';

import '../../constants/colors.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DetailsArguments;
    _todoController.text = args.todo.text;

    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: buildAppBar(),
      body: Column(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
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
              onChanged: (text) {
                print("onChanged: $text");
              },
              controller: _todoController,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Row(
          children: [],
        ),
      ]),
    );
  }

  buildAppBar() {
    return AppBar(
      backgroundColor: tdBlue,
      elevation: 2,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Expanded(child: Center(child: Text('Details'))),
          IconButton(
            icon: const Icon(Icons.done),
            color: Colors.white,
            iconSize: 30,
            onPressed: _save,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.white,
            iconSize: 30,
            onPressed: _delete,
          ),
        ],
      ),
    );
  }

  void _save() {
    final args = ModalRoute.of(context)!.settings.arguments as DetailsArguments;
    var todo = args.todo;
    var result = DetailsResult(
        DetailsResult.actionEdit, todo.copy(text: _todoController.text));
    Navigator.of(context, rootNavigator: true).pop(result);
  }

  void _delete() {
    final args = ModalRoute.of(context)!.settings.arguments as DetailsArguments;
    var todo = args.todo;
    var result = DetailsResult(DetailsResult.actionDelete, todo);
    Navigator.of(context, rootNavigator: true).pop(result);
  }
}