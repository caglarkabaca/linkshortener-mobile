import 'dart:convert';

import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinksResponseDTO.dart';

class ShortLinkService {
  Future<ShortLinksResponseDTO?> getUserShortLinksService(
      {String? nameSearch,
      int? page,
      int? take,
      String? sortBy,
      bool? isDescending,
      Function(ErrorResponseDTO dto)? onError}) async {
    var queryBuilder = QueryBuilder();

    var params = {
      'nameSearch': nameSearch,
      'page': page?.toString(),
      'take': take?.toString(),
      'sortBy': sortBy,
      'isDescending': isDescending?.toString(),
    };

    params.forEach((key, value) {
      if (value != null) {
        queryBuilder.add(key, value);
      }
    });

    final response =
        await Httpbase().get('/ShortLink/GetAll', queryBuilder.build());

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
