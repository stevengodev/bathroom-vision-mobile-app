import 'package:bathroom_vision/shared/enums/role.dart';

class UserRequest {
  final String name;
  final String email;
  final String password;
  final Role role;

  UserRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "role": role.name,
    };
  }

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: Role.values.firstWhere((r) => r.name == json['role']),
    );
  }
}