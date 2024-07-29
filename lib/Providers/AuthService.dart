import 'package:link_shortener_mobile/Models/DTO/UserLoginRequestDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/UserLoginResponseDTO.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String BASE_URL = "https://10.0.2.2:7031";

class AuthService {
  Future<http.Response> loginService(String userName, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/Auth/Login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          UserLoginRequestDTO(userName: userName, password: password)),
    );
    return response;
  }
}
