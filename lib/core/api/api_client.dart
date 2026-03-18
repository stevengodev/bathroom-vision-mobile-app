import 'package:bathroom_vision/core/interceptors/auth_interceptor.dart';
import 'package:bathroom_vision/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {

  late final Dio dio;

  ApiClient(SecureStorage storage) {

    dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env["API_URL"]!,
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor(storage));
  }
}