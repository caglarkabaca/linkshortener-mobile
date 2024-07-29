class User {
  int? id;
  String? userName;
  String? password;
  String? role;
  bool? isActive;
  String? token;
  String? email;
  String? firstName;
  String? lastName;
  String? phoneNumber;

  User(
      {this.id,
        this.userName,
        this.password,
        this.role,
        this.isActive,
        this.token,
        this.email,
        this.firstName,
        this.lastName,
        this.phoneNumber});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    password = json['password'];
    role = json['role'];
    isActive = json['isActive'];
    token = json['token'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['role'] = this.role;
    data['isActive'] = this.isActive;
    data['token'] = this.token;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}