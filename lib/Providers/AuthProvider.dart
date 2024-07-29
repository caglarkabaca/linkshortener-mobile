import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/UserLoginResponseDTO.dart';
import 'package:link_shortener_mobile/Providers/AuthService.dart';

import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();

  late UserLoginResponseDTO _responseDTO;
  UserLoginResponseDTO get responseDTO => _responseDTO;
  bool isResponse = false;

  late ErrorDTO _errorDTO;
  ErrorDTO get errorDTO => _errorDTO;
  bool isError = false;

  bool isLoading = false;
  Future<void> login(String userName, String password) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.loginService(userName, password);
    if (response.statusCode == 200) {
      isError = false;
      isResponse = true;

      _responseDTO = UserLoginResponseDTO.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      isError = true;
      isResponse = false
      ;
      _errorDTO =
          ErrorDTO.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    isLoading = false;
    notifyListeners();
  }
}
