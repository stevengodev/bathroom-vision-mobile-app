
import 'package:bathroom_vision/core/api/api_client.dart';

class AuthApi {

  final ApiClient apiClient;

  AuthApi(this.apiClient);

  Future<String> loginWithGoogle(String idToken) async {

    final response = await apiClient.dio.post(
      "/api/auth/google",
      data: {
        "idToken": idToken,
      },
    );

    print("Respuesta del login: ${response.data}");

    return response.data["accessToken"];
  }

  Future<String> login(String email, String password) async {

    final response = await apiClient.dio.post(
      "/api/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );

    print("Respuesta del login: ${response.data}");

    return response.data["accessToken"];
  }

}