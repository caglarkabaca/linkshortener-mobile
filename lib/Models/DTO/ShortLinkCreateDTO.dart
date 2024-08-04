class ShortLinkCreateDTO {
  String? name;
  String? redirectUrl;
  String? uniqueCode;

  ShortLinkCreateDTO({this.name, this.redirectUrl, this.uniqueCode});

  ShortLinkCreateDTO.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    redirectUrl = json['redirectUrl'];
    uniqueCode = json['uniqueCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['redirectUrl'] = this.redirectUrl;
    data['uniqueCode'] = this.uniqueCode;
    return data;
  }
}
