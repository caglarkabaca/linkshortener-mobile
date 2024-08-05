class ShortLinkLog {
  int? id;
  int? shortLinkId;
  String? redirectTime;
  String? userAgent;
  String? ipAddress;
  String? headersJson;
  bool liveLog = false;

  ShortLinkLog({
    this.id,
    this.shortLinkId,
    this.redirectTime,
    this.userAgent,
    this.ipAddress,
    this.headersJson,
  });

  ShortLinkLog.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['Id'];
    shortLinkId = json['shortLinkId'] ?? json['ShortLinkId'];
    redirectTime = json['redirectTime'] ?? json['RedirectTime'];
    userAgent = json['userAgent'] ?? json['UserAgent'];
    ipAddress = json['ipAddress'] ?? json['IpAddress'];
    headersJson = json['headersJson'] ?? json['HeadersJson'];
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
