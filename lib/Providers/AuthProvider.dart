import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:link_shortener_mobile/Core/LocalStorage.dart';
import 'package:link_shortener_mobile/Core/MainHub.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Providers/AuthService.dart';
import 'package:link_shortener_mobile/Views/MainView.dart';
import 'package:link_shortener_mobile/Views/SplashView.dart';

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
      await LocalStorage().setToken(response.token!);
      await LocalStorage().setUser(response.user!);

      Httpbase().setToken(response.token ?? 'WTF MAN');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const MainView()),
      );
      await resetState();
      return;
    } else {
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final response = await LocalStorage().clearToken();

    isLoading = false;

    if (response) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const SplashView()));
    } else {
      notifyListeners();
    }
  }

  Future<void> resetState() async {
    isLoading = false;
    errorDto = null;
    _response = null;
    notifyListeners();
  }
}
