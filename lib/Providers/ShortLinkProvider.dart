import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinksResponseDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/ShortLinksResponseDTO.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkService.dart';

class ShortLinkProvider extends ChangeNotifier {
  final _service = ShortLinkService();

  dynamic _response;

  dynamic get response => _response;

  bool isLoading = false;

  ErrorResponseDTO? errorDto;

  Future<void> getUserShortLinks(
      {String? nameSearch,
      int? page,
      int? take,
      String? sortBy,
      bool? isDescending,
      bool? refresh}) async {
    if (refresh == false) {
      isLoading = true;
      notifyListeners();
    }

    final response = await _service.getUserShortLinksService(
        nameSearch: nameSearch,
        page: page,
        take: take,
        sortBy: sortBy,
        isDescending: isDescending,
        onError: (dto) {
          errorDto = dto;
        });

    _response = response;
    isLoading = false;
    notifyListeners();
  }
}
