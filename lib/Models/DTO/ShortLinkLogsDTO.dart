import 'package:link_shortener_mobile/Models/ShortLinkLog.dart';

class ShortLinkLogsResponseDTO {
  List<ShortLinkLog>? shortLinkLogs;
  int? page;
  int? take;
  int? totalCount;

  ShortLinkLogsResponseDTO(
      {this.shortLinkLogs, this.page, this.take, this.totalCount});

  ShortLinkLogsResponseDTO.fromJson(Map<String, dynamic> json) {
    if (json['shortLinkLogs'] != null) {
      shortLinkLogs = <ShortLinkLog>[];
      json['shortLinkLogs'].forEach((v) {
        shortLinkLogs!.add(new ShortLinkLog.fromJson(v));
      });
    }
    page = json['page'];
    take = json['take'];
    totalCount = json['totalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shortLinkLogs != null) {
      data['shortLinkLogs'] =
          this.shortLinkLogs!.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['take'] = this.take;
    data['totalCount'] = this.totalCount;
    return data;
  }
}
