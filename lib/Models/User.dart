class User {
  String? userName;
  bool? isActive;
  String? email;
  String? phoneNumber;

  User({this.userName, this.isActive, this.email, this.phoneNumber});

  User.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    isActive = json['isActive'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['isActive'] = this.isActive;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
