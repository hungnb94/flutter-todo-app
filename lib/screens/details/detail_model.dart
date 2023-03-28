import 'package:flutter/foundation.dart';
import 'package:todo_app/model/todo.dart';

class DetailModel extends ChangeNotifier {
  late ToDo _item;

  ToDo get item => _item;

  set item(ToDo item) {
    _item = item;
    notifyListeners();
  }
}
