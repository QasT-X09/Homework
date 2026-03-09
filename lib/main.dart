import 'package:flutter/material.dart';

import 'patterns/mvc/tasks_mvc_screen.dart';
import 'patterns/mvp/tasks_mvp_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MVC vs MVP Demo',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const PatternsHomeScreen(),
    );
  }
}

class PatternsHomeScreen extends StatelessWidget {
  const PatternsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Список задач: MVC vs MVP')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _NavCard(
            title: 'MVC экран задач',
            subtitle: 'Контроллер управляет View + моделью сервиса',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TasksMvcScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _NavCard(
            title: 'MVP экран задач',
            subtitle: 'Presenter отдельно, View пассивная',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TasksMvpScreen()),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Сравнение:\n'
            '• MVC: быстрее старт, но View знает больше о состоянии.\n'
            '• MVP: чуть больше кода, зато проще тестировать Presenter и менять UI без правок бизнес-логики.',
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
