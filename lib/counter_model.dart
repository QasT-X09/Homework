import 'package:shared_preferences/shared_preferences.dart';

class CounterModel {
  int counter = 0;

  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt('counter') ?? 0;
  }

  Future<void> saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', counter);
  }

  Future<void> increment() async {
    counter++;
    await saveCounter();
  }
}
