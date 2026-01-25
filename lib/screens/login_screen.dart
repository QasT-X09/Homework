import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _tryLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final auth = Provider.of<AuthService>(context, listen: false);
    final ok = await auth.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Неверный логин или пароль')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Логин'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Введите логин' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (v) => (v == null || v.isEmpty) ? 'Введите пароль' : null,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _tryLogin, child: const Text('Войти')),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/register'),
                child: const Text('Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
