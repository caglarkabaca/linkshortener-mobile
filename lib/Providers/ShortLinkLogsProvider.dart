import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Providers/Services/ShortLinkService.dart';

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
        take: 10,
        isDescending: isDescending,
        onError: (dto) {
          errorDto = dto;
        });
    _response = response;
    isLoading = false;
    notifyListeners();
  }

  Future<void> resetState(BuildContext context) async {
    isLoading = false;
    errorDto = null;
    _response = null;
    notifyListeners();
  }
}
