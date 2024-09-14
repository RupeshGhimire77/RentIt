import 'dart:ffi';

class User {
  String? name;
  String? role;
  String? email;
  String? password;
  String? confirmPassword;
  String? mobileNumber;

  User(
      {this.name,
      this.email,
      this.password,
      this.confirmPassword,
      this.role,
      this.mobileNumber});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    mobileNumber = json['mobileNumber'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    data['mobileNumber'] = this.mobileNumber;
    data['role'] = this.role;
    return data;
  }
}
