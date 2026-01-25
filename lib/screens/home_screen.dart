import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Маркетплейс — Главная'),
        actions: [
          IconButton(
            onPressed: () {
              // don't await here to avoid using BuildContext after an async gap
              auth.logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Добро пожаловать, ${auth.currentUser ?? 'гость'}!', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Здесь будет список товаров (заглушка).'),
          ],
        ),
      ),
    );
  }
}
