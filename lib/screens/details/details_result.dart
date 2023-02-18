import 'package:todo_app/model/todo.dart';

class DetailsResult {
  final String action;
  final ToDo todo;

  DetailsResult(this.action, this.todo);

  bool isEdited() {
    return action == actionEdit;
  }

  bool isDeleted() {
    return action == actionDelete;
  }

  static const actionEdit = 'edit';
  static const actionDelete = 'delete';

  static DetailsResult edit(ToDo todo) {
    return DetailsResult(actionEdit, todo);
  }

  static DetailsResult delete(ToDo todo) {
    return DetailsResult(actionDelete, todo);
  }
}
