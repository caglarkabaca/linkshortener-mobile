class ShortLinkLog {
  int? id;
  int? shortLinkId;
  String? redirectTime;
  String? userAgent;
  String? ipAddress;
  String? headersJson;

  ShortLinkLog(
      {this.id,
      this.shortLinkId,
      this.redirectTime,
      this.userAgent,
      this.ipAddress,
      this.headersJson});

  ShortLinkLog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shortLinkId = json['shortLinkId'];
    redirectTime = json['redirectTime'];
    userAgent = json['userAgent'];
    ipAddress = json['ipAddress'];
    headersJson = json['headersJson'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shortLinkId'] = this.shortLinkId;
    data['redirectTime'] = this.redirectTime;
    data['userAgent'] = this.userAgent;
    data['ipAddress'] = this.ipAddress;
    data['headersJson'] = this.headersJson;
    return data;
  }
}
