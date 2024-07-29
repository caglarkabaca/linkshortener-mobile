import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Providers/AuthService.dart';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();

  late dynamic _response;
  dynamic get response => _response;
  var isResponse = false;

  bool isLoading = false;
  Future<void> login(String userName, String password) async {
    isLoading = true;
    isResponse = false;
    notifyListeners();

    final response = await _service.loginService(userName, password);
    _response = response;

    isLoading = false;
    isResponse = true;
    notifyListeners();
  }
}
