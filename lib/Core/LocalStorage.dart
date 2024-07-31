import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  late SharedPreferences prefs;
  LocalStorage._internal();
  static final _instance = LocalStorage._internal();
  factory LocalStorage() {
    return _instance;
  }

  Future<bool> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user_token') == null) {
      return false;
    }
    return true;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<bool> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString('user_token', token);
  }

  Future<bool> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove('user_token');
  }

}