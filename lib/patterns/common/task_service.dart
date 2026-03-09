import 'task_item.dart';

class TaskService {
  final List<TaskItem> _storage = [];

  Future<List<TaskItem>> load() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List<TaskItem>.from(_storage);
  }

  Future<List<TaskItem>> add(String title) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (title.trim().isEmpty) {
      throw ArgumentError('Название задачи не может быть пустым');
    }

    _storage.insert(
      0,
      TaskItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
      ),
    );
    return List<TaskItem>.from(_storage);
  }
}
