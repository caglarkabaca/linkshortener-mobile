import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/UserLoginRequestDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/UserLoginResponseDTO.dart';
import 'dart:convert';

import 'package:link_shortener_mobile/Models/DTO/UserRegisterRequestDTO.dart';

import '../Models/User.dart';

const String BASE_URL = "https://10.0.2.2:7031";

class AuthService {
  Future<UserLoginResponseDTO?> loginService(String userName, String password,
      {Function(ErrorResponseDTO dto)? onError}) async {
    final response = await Httpbase().post(
        '/Auth/Login',
        jsonEncode(
            UserLoginRequestDTO(userName: userName, password: password)));
    if (response.statusCode == 200) {
      return UserLoginResponseDTO.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      if (onError != null) {
        onError(ErrorResponseDTO.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>));
      }
      return null;
    }
  }

  Future<User?> registerService(
      String userName, String password, String email, String phoneNumber,
      {Function(ErrorResponseDTO dto)? onError}) async {
    final response = await Httpbase().post(
        '/Auth/Register',
        jsonEncode(UserRegisterRequestDTO(
            userName: userName,
            password: password,
            email: email,
            phoneNumber: phoneNumber)));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      if (onError != null) {
        onError(ErrorResponseDTO.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>));
      }
      return null;
    }
  }
}
