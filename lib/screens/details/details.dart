import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/screens/details/detail_model.dart';
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
    var todo = context.watch<DetailModel>();
    _todoController.text = todo.item.text;

    return Scaffold(
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
          Expanded(child: Center(child: Text(S.of(context).details))),
          IconButton(
            icon: const Icon(Icons.done),
            color: Colors.white,
            iconSize: 30,
            onPressed: _save,
          ),
          IconButton(
            icon: const Icon(Icons.delete, key: Key('icon_delete'),),
            color: Colors.white,
            iconSize: 30,
            onPressed: _delete,
          ),
        ],
      ),
    );
  }

  void _save() {
    final detail = context.read<DetailModel>();
    var todo = detail.item;
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
