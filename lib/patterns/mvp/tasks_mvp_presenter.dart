import '../common/app_error_handler.dart';
import '../common/task_item.dart';
import '../common/task_service.dart';

abstract class TasksMvpView {
  void showLoading(bool value);
  void showTasks(List<TaskItem> tasks);
  void showError(String message);
}

class TasksMvpPresenter {
  final TaskService _service;
  final AppErrorHandler _errorHandler;
  TasksMvpView? _view;

  TasksMvpPresenter({required TaskService service, required AppErrorHandler errorHandler})
      : _service = service,
        _errorHandler = errorHandler;

  void attach(TasksMvpView view) {
    _view = view;
  }

  void detach() {
    _view = null;
  }

  Future<void> loadTasks() async {
    _view?.showLoading(true);
    try {
      final tasks = await _service.load();
      _view?.showTasks(tasks);
    } catch (error) {
      _view?.showError(_errorHandler.handle(error));
    } finally {
      _view?.showLoading(false);
    }
  }

  Future<void> addTask(String title) async {
    try {
      final tasks = await _service.add(title);
      _view?.showTasks(tasks);
    } catch (error) {
      _view?.showError(_errorHandler.handle(error));
    }
  }
}
