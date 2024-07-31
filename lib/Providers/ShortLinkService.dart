import 'dart:convert';

import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinksResponseDTO.dart';

class ShortLinkService {
  Future<ShortLinksResponseDTO?> getUserShortLinksService(
      {Function(ErrorResponseDTO dto)? onError}) async {
    final response = await Httpbase().get('/ShortLink/UserLinks');

    if (response.statusCode == 200) {
      return ShortLinksResponseDTO.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      if (onError != null) {
        onError(ErrorResponseDTO.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>));
      }
      return null;
    }
  }
}
