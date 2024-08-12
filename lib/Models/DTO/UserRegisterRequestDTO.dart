class UserRegisterRequestDTO {
  String? userName;
  String? password;
  String? role;
  String? email;
  String? phoneNumber;

  UserRegisterRequestDTO(
      {this.userName, this.password, this.role, this.email, this.phoneNumber});

  UserRegisterRequestDTO.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    password = json['password'];
    role = json['role'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['role'] = this.role;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
