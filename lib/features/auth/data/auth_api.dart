
import 'package:bathroom_vision/core/api/api_client.dart';

import 'package:bathroom_vision/core/errors/api_exception.dart';
import 'package:dio/dio.dart';

class AuthApi {

  final ApiClient apiClient;

  AuthApi(this.apiClient);

  Future<String> register(String name, String email, String password, String role) async {
    try {
      final response = await apiClient.dio.post(
        "/api/auth/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
          "role": role,
        },
      );

      print("Respuesta del registro: ${response.data}");

      return response.data["accessToken"];
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 409) {
        throw ApiException("Ese correo ya está registrado");
      }
      throw ApiException("Error al registrar el usuario");
    } catch (e) {
      throw ApiException("Error inesperado al registrar");
    }
  }

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
    try {
      final response = await apiClient.dio.post(
        "/api/auth/login",
        data: {
          "email": email,
          "password": password,
        },
      );

      print("Respuesta del login: ${response.data}");

      return response.data["accessToken"];
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403 || e.response?.statusCode == 404) {
        throw ApiException("Correo o contraseña incorrectos");
      }
      throw ApiException("Error al iniciar sesión");
    } catch (e) {
      throw ApiException("Error inesperado al iniciar sesión");
    }
  }

}