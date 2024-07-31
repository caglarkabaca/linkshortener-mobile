import 'package:link_shortener_mobile/Models/User.dart';

class ShortLink {
  int? id;
  String? name;
  String? redirectUrl;
  String? uniqueCode;
  User? createdBy;
  String? createDate;
  String? updateDate;
  bool? isActive;
  int? clickCount;

  ShortLink(
      {this.id,
      this.name,
      this.redirectUrl,
      this.uniqueCode,
      this.createdBy,
      this.createDate,
      this.updateDate,
      this.isActive,
      this.clickCount});

  ShortLink.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    redirectUrl = json['redirectUrl'];
    uniqueCode = json['uniqueCode'];
    createdBy =
        json['createdBy'] != null ? new User.fromJson(json['createdBy']) : null;
    createDate = json['createDate'];
    updateDate = json['updateDate'];
    isActive = json['isActive'];
    clickCount = json['clickCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['redirectUrl'] = this.redirectUrl;
    data['uniqueCode'] = this.uniqueCode;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['createDate'] = this.createDate;
    data['updateDate'] = this.updateDate;
    data['isActive'] = this.isActive;
    data['clickCount'] = this.clickCount;
    return data;
  }
}
