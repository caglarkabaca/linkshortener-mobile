import 'dart:convert';

import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinkCreateDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinkLogsDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinksResponseDTO.dart';

class ShortLinkService {
  Future<ShortLinkLogsResponseDTO?> getShortLinkLogsService(
      {required int shortLinkId,
      int? page,
      int? take,
      bool? isDescending,
      Function(ErrorResponseDTO dto)? onError}) async {
    var queryBuilder = QueryBuilder();
    var params = {
      'page': page?.toString(),
      'take': take?.toString(),
      'isDescending': isDescending?.toString(),
    };

    params.forEach((key, value) {
      if (value != null) {
        queryBuilder.add(key, value);
      }
    });

    final response = await Httpbase()
        .get('/ShortLinkLog/$shortLinkId', queryBuilder.build());

    if (response.statusCode == 200) {
      return ShortLinkLogsResponseDTO.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      if (onError != null) {
        onError(ErrorResponseDTO.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>));
      }
      return null;
    }
  }

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

  Future<bool> createShortLinkService(
      {required String name,
      required String redirectLink,
      required String? uniqueCode,
      Function(ErrorResponseDTO dto)? onError}) async {
    final response = await Httpbase().post(
        '/ShortLink',
        jsonEncode(ShortLinkCreateDTO(
            name: name, redirectUrl: redirectLink, uniqueCode: uniqueCode)));

    if (response.statusCode == 200) {
      return true;
    } else {
      if (onError != null) {
        onError(ErrorResponseDTO.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>));
      }
      return false;
    }
  }

  Future<bool> deleteShortLinkService(
      {required int linkId, Function(ErrorResponseDTO dto)? onError}) async {
    final response = await Httpbase().delete('/ShortLink/$linkId');
    if (response.statusCode == 200) {
      return true;
    } else {
      if (onError != null) {
        onError(ErrorResponseDTO.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>));
      }
      return false;
    }
  }
}
