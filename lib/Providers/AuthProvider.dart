import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Providers/AuthService.dart';
import 'package:link_shortener_mobile/Views/MainView.dart';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();

  late dynamic _response;

  dynamic get response => _response;
  bool isLoading = false;

  ErrorResponseDTO? errorDto;

  Future<void> login(
      BuildContext context, String userName, String password) async {
    isLoading = true;
    notifyListeners();

    final response =
        await _service.loginService(userName, password, onError: (dto) {
          errorDto = dto;
        });
    _response = response;
    isLoading = false;

    if (response != null) {
      // token save
      // httpbase ekle
      // redirect sayfa
      // return
    } else {
      notifyListeners();
    }
  }
}
