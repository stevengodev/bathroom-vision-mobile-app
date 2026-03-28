import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/features/auth/models/user_response.dart';

class UserApi {
  final ApiClient apiClient;

  UserApi(this.apiClient);

  Future<UserResponse> getProfile() async {
    final response = await apiClient.dio.get("/api/users/profile");

    print("Respuesta del perfil: ${response.data}");

    return UserResponse.fromJson(response.data);
  }
}
