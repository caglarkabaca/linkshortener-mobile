import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkService.dart';

class ShortLinkLogsProvider extends ChangeNotifier {
  final _service = ShortLinkService();

  dynamic _response;

  dynamic get response => _response;

  bool isLoading = false;

  ErrorResponseDTO? errorDto;

  Future<void> getShortLinkLogs(
      {required int shortLinkId,
      String? nameSearch,
      int? page,
      int? take,
      String? sortBy,
      bool? isDescending,
      bool? refresh}) async {
    if (refresh == false) {
      isLoading = true;
      notifyListeners();
    }

    final response = await _service.getShortLinkLogsService(
        shortLinkId: shortLinkId,
        page: page,
        take: take,
        isDescending: isDescending,
        onError: (dto) {
          errorDto = dto;
        });

    _response = response;
    isLoading = false;
    notifyListeners();
  }
}
