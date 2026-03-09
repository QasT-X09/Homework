import 'package:flutter/material.dart';

import '../common/app_error_handler.dart';
import '../common/task_item.dart';
import '../common/task_service.dart';
import 'tasks_mvp_presenter.dart';

class TasksMvpScreen extends StatefulWidget {
  const TasksMvpScreen({super.key});

  @override
  State<TasksMvpScreen> createState() => _TasksMvpScreenState();
}

class _TasksMvpScreenState extends State<TasksMvpScreen> implements TasksMvpView {
  late final TasksMvpPresenter _presenter;
  final _textController = TextEditingController();
  List<TaskItem> _tasks = [];
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _presenter = TasksMvpPresenter(
      service: TaskService(),
      errorHandler: AppErrorHandler(),
    );
    _presenter.attach(this);
    _presenter.loadTasks();
  }

  @override
  void dispose() {
    _presenter.detach();
    _textController.dispose();
    super.dispose();
  }

  @override
  void showLoading(bool value) {
    if (!mounted) return;
    setState(() => _loading = value);
  }

  @override
  void showTasks(List<TaskItem> tasks) {
    if (!mounted) return;
    setState(() {
      _tasks = tasks;
      _errorMessage = null;
    });
  }

  @override
  void showError(String message) {
    if (!mounted) return;
    setState(() => _errorMessage = message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MVP: список задач')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(labelText: 'Новая задача'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    await _presenter.addTask(_textController.text);
                    _textController.clear();
                  },
                  child: const Text('Добавить'),
                ),
              ],
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) => ListTile(title: Text(_tasks[index].title)),
                  ),
          ),
        ],
      ),
    );
  }
}
