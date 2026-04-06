import 'package:flutter/foundation.dart';

import '../common/app_error_handler.dart';
import '../common/task_item.dart';
import '../common/task_service.dart';

class TasksMvcController extends ChangeNotifier {
  TasksMvcController({required TaskService service, required AppErrorHandler errorHandler})
      : _service = service,
        _errorHandler = errorHandler;

  final TaskService _service;
  final AppErrorHandler _errorHandler;

  List<TaskItem> tasks = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadTasks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      tasks = await _service.load();
    } catch (error) {
      errorMessage = _errorHandler.handle(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    errorMessage = null;
    try {
      tasks = await _service.add(title);
      notifyListeners();
    } catch (error) {
      errorMessage = _errorHandler.handle(error);
      notifyListeners();
    }
  }
}
