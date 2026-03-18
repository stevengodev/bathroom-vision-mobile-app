
import 'package:bathroom_vision/core/api/api_client.dart';

class BathroomApi {

  final ApiClient apiClient;

  BathroomApi(this.apiClient);

  Future<String> loginWithGoogle(String idToken) async {

    final response = await apiClient.dio.post(
      "/api/auth/google",
      data: {
        "idToken": idToken,
      },
    );

    return response.data["token"];
  }

}