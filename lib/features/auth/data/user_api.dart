import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/features/auth/models/user_request.dart';
import 'package:bathroom_vision/features/auth/models/user_response.dart';
import 'package:bathroom_vision/shared/enums/role.dart';

class UserApi {
  final ApiClient apiClient;

  UserApi(this.apiClient);

  Future<UserResponse> getProfile() async {
    final response = await apiClient.dio.get("/api/users/profile");

    print("Respuesta del perfil: ${response.data}");

    return UserResponse.fromJson(response.data);
  }

  Future<List<UserResponse>> getByRole(Role role) async {
    final response = await apiClient.dio.get(
      "/api/users",
      queryParameters: {"role": role.name},
    );

    print("Respuesta de getByRole: ${response.data}");

    return (response.data as List)
        .map((e) => UserResponse.fromJson(e))
        .toList();
  }

  Future<List<UserResponse>> getAllByRoles(List<Role> roles) async {
    final response = await apiClient.dio.get(
      "/api/users",
      queryParameters: {"roles": roles.map((r) => r.name).toList()},
    );

    print("Respuesta de getAllByRoles: ${response.data}");

    return (response.data as List)
        .map((e) => UserResponse.fromJson(e))
        .toList();
  }

  Future<UserResponse> updateUser({
    required int id,
    required UserRequest request,
  }) async {
    final response = await apiClient.dio.put("/api/users/$id", data: request.toJson());

    print("Respuesta de updateUser: ${response.data}");

    return UserResponse.fromJson(response.data);
  }
}
