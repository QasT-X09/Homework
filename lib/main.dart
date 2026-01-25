import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = AuthService();
  await auth.init();
  runApp(MyApp(auth: auth));
}

class MyApp extends StatelessWidget {
  final AuthService auth;
  const MyApp({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: auth,
      child: MaterialApp(
        title: 'Маркетплейс',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routes: {
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
        },
        home: Consumer<AuthService>(builder: (context, auth, _) {
          if (auth.isLoggedIn) {
            return const HomeScreen();
          }
          return const LoginScreen();
        }),
      ),
    );
  }
}
