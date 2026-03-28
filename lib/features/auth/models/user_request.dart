class UserRequest {
  final String name;
  final String email;
  final String password;

  UserRequest({
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
}