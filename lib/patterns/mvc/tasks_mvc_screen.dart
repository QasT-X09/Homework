import 'package:flutter/material.dart';

import '../common/app_error_handler.dart';
import '../common/task_service.dart';
import 'tasks_mvc_controller.dart';

class TasksMvcScreen extends StatefulWidget {
  const TasksMvcScreen({super.key});

  @override
  State<TasksMvcScreen> createState() => _TasksMvcScreenState();
}

class _TasksMvcScreenState extends State<TasksMvcScreen> {
  late final TasksMvcController _controller;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TasksMvcController(
      service: TaskService(),
      errorHandler: AppErrorHandler(),
    )..loadTasks();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MVC: список задач')),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            children: [
              _InputRow(
                controller: _textController,
                onAdd: () async {
                  await _controller.addTask(_textController.text);
                  _textController.clear();
                },
              ),
              if (_controller.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    _controller.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Expanded(
                child: _controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _controller.tasks.length,
                        itemBuilder: (context, index) {
                          final item = _controller.tasks[index];
                          return ListTile(title: Text(item.title));
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const _InputRow({required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Новая задача'),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(onPressed: onAdd, child: const Text('Добавить')),
        ],
      ),
    );
  }
}
