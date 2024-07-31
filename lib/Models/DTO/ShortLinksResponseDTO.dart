import 'package:link_shortener_mobile/Models/ShortLink.dart';

class ShortLinksResponseDTO {
  List<ShortLink>? shortLinks;
  int? page;
  int? take;
  int? totalCount;

  ShortLinksResponseDTO(
      {this.shortLinks, this.page, this.take, this.totalCount});

  ShortLinksResponseDTO.fromJson(Map<String, dynamic> json) {
    if (json['shortLinks'] != null) {
      shortLinks = <ShortLink>[];
      json['shortLinks'].forEach((v) {
        shortLinks!.add(new ShortLink.fromJson(v));
      });
    }
    page = json['page'];
    take = json['take'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shortLinks != null) {
      data['shortLinks'] = this.shortLinks!.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['take'] = this.take;
    data['totalCount'] = this.totalCount;
    return data;
  }
}
