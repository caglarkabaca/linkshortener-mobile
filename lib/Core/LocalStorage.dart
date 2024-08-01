import 'dart:convert';

import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:link_shortener_mobile/Models/User.dart';
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
    var token = prefs.getString('user_token');
    if (token == null) {
      return false;
    }
    Httpbase().setToken(token);
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

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonUser = await prefs.getString('user');
    if (jsonUser == null) return null;
    return User.fromJson(jsonDecode(jsonUser) as Map<String, dynamic>);
  }

  Future<bool> setUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString('user', jsonEncode(user));
  }
}
