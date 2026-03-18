import 'package:bathroom_vision/features/auth/models/user_response.dart';

class AuthResponse {
  final String accessToken;
  final String tokenType;
  final String expiresIn;
  final UserResponse user;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'],
      tokenType: json['tokenType'],
      expiresIn: json['expiresIn'],
      user: UserResponse.fromJson(json['user']),
    );
  }

}