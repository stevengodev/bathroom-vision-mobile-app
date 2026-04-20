import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/core/errors/api_exception.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_request.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_response.dart';

class CleaningScheduleApi {
  final ApiClient apiClient;

  CleaningScheduleApi(this.apiClient);

  Future<List<CleaningScheduleResponse>> getAll() async {
    try {
      final response = await apiClient.dio.get("/api/schedules/cleaning");

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => CleaningScheduleResponse.fromJson(e)).toList();
      } else {
        throw ApiException(
          "Error al obtener horarios",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al obtener horarios");
    }
  }

  Future<List<CleaningScheduleResponse>> getMySchedules() async {
    try {
      final response = await apiClient.dio.get("/api/schedules/cleaning/me");

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => CleaningScheduleResponse.fromJson(e)).toList();
      } else {
        throw ApiException(
          "Error al obtener mis horarios",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al obtener mis horarios");
    }
  }

  Future<List<CleaningScheduleResponse>> getByBathroom(int bathroomId) async {
    try {
      final response = await apiClient.dio.get(
        "/api/schedules/cleaning/bathroom/$bathroomId",
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => CleaningScheduleResponse.fromJson(e)).toList();
      } else {
        throw ApiException(
          "Error al obtener por baño",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al obtener por baño");
    }
  }

  Future<CleaningScheduleResponse> getById(int id) async {
    try {
      final response = await apiClient.dio.get(
        "/api/schedules/cleaning/$id",
      );

      if (response.statusCode == 200) {
        return CleaningScheduleResponse.fromJson(response.data);
      } else {
        throw ApiException(
          "Error al obtener horario",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al obtener horario");
    }
  }

  Future<CleaningScheduleResponse> create(CleaningScheduleRequest request) async {
    try {
      final response = await apiClient.dio.post(
        "/api/schedules/cleaning",
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CleaningScheduleResponse.fromJson(response.data);
      } else {
        throw ApiException(
          "Error al crear horario",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al crear horario");
    }
  }

  Future<CleaningScheduleResponse> update(int id, CleaningScheduleRequest request) async {
    try {
      final response = await apiClient.dio.put(
        "/api/schedules/cleaning/$id",
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return CleaningScheduleResponse.fromJson(response.data);
      } else {
        throw ApiException(
          "Error al actualizar",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al actualizar");
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await apiClient.dio.delete(
        "/api/schedules/cleaning/$id",
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          "Error al eliminar",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al eliminar");
    }
  }
}