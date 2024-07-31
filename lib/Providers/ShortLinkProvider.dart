import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkService.dart';

class ShortLinkProvider extends ChangeNotifier {
  final _service = ShortLinkService();
  late dynamic _response;

  dynamic get response => _response;
  bool isLoading = false;

  ErrorResponseDTO? errorDto;

  Future<void> getUserShortLinks() async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getUserShortLinksService(onError: (dto) {
      errorDto = dto;
    });

    _response = response;
    isLoading = false;
    notifyListeners();
  }
}
