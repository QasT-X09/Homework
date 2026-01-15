import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// models imported where needed
import '../providers/todo_provider.dart';
import 'todo_detail_screen.dart';
import 'todo_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список задач'),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, _) {
          final items = provider.items;
          if (items.isEmpty) {
            return const Center(child: Text('Нет задач'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final todo = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (_) => provider.toggleCompleted(todo.id),
                  ),
                  title: Text(todo.title),
                  subtitle: todo.description != null ? Text(todo.description!) : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TodoEditScreen(todo: todo),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => provider.removeTodo(todo.id),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TodoDetailScreen(todo: todo),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TodoEditScreen()),
          );
        },
      ),
    );
  }
}
