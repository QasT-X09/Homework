import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo.dart';
import '../providers/todo_provider.dart';

class TodoEditScreen extends StatefulWidget {
  final Todo? todo;

  const TodoEditScreen({super.key, this.todo});

  @override
  State<TodoEditScreen> createState() => _TodoEditScreenState();
}

class _TodoEditScreenState extends State<TodoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;

  @override
  void initState() {
    super.initState();
    _title = widget.todo?.title ?? '';
    _description = widget.todo?.description;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final provider = Provider.of<TodoProvider>(context, listen: false);
    if (widget.todo == null) {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        description: _description,
      );
      provider.addTodo(newTodo);
    } else {
      final updated = widget.todo!.copyWith(title: _title, description: _description);
      provider.updateTodo(widget.todo!.id, updated);
      // If editing from detail screen, pop twice to return to the list
      Navigator.pop(context);
      Navigator.pop(context);
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.todo != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Редактировать' : 'Новая задача')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Заголовок'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите заголовок' : null,
                onSaved: (v) => _title = v!.trim(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Описание'),
                onSaved: (v) => _description = v?.trim(),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Сохранить'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
