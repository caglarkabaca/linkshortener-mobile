import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Models/ShortLink.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkService.dart';
import 'package:link_shortener_mobile/Views/DetailView.dart';

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

// todo ShortLink Silme Provider

  Future<void> deleteShortLink(BuildContext context, int linkId) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.deleteShortLinkService(
        linkId: linkId,
        onError: (dto) {
          errorDto = dto;
        });

    if (response == true) {
      Navigator.pop(context);
    } else {
      _response = response;
      isLoading = false;
      notifyListeners();
    }
  }
}
