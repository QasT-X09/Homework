import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  static const _usersKey = 'users';
  static const _currentUserKey = 'current_user';

  SharedPreferences? _prefs;
  final Map<String, String> _users = {};
  String? _currentUser;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final usersJson = _prefs!.getString(_usersKey);
    if (usersJson != null) {
      final Map<String, dynamic> map = jsonDecode(usersJson);
      map.forEach((k, v) {
        _users[k] = v.toString();
      });
    }
    _currentUser = _prefs!.getString(_currentUserKey);
  }

  String? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> register(String username, String password) async {
    if (username.isEmpty || password.isEmpty) return false;
    if (_users.containsKey(username)) return false;
    _users[username] = password;
    await _saveUsers();
    return true;
  }

  Future<bool> login(String username, String password) async {
    final stored = _users[username];
    if (stored == null) return false;
    if (stored != password) return false;
    _currentUser = username;
    await _prefs!.setString(_currentUserKey, username);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    await _prefs!.remove(_currentUserKey);
    notifyListeners();
  }

  Future<void> _saveUsers() async {
    final json = jsonEncode(_users);
    await _prefs!.setString(_usersKey, json);
  }
}
