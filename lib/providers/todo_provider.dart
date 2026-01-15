import 'package:flutter/foundation.dart';

import '../models/todo.dart';
import '../services/sample_data.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> _items = List<Todo>.from(SampleData.todos);

  List<Todo> get items => List.unmodifiable(_items);

  void addTodo(Todo todo) {
    _items.insert(0, todo);
    notifyListeners();
  }

  void updateTodo(String id, Todo updated) {
    final index = _items.indexWhere((t) => t.id == id);
    if (index != -1) {
      _items[index] = updated;
      notifyListeners();
    }
  }

  void removeTodo(String id) {
    _items.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleCompleted(String id) {
    final index = _items.indexWhere((t) => t.id == id);
    if (index != -1) {
      _items[index].completed = !_items[index].completed;
      notifyListeners();
    }
  }
}
