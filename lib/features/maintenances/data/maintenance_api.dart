import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/core/errors/api_exception.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_request.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';

class MaintenanceApi {
  final ApiClient apiClient;

  MaintenanceApi(this.apiClient);

  Future<List<MaintenanceResponse>> getAll() async {
    try {
      final response = await apiClient.dio.get("/api/maintenances"); 

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => MaintenanceResponse.fromJson(e)).toList();
      } else {
        throw ApiException(
          "Error al obtener mantenimientos",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al obtener mantenimientos");
    }
  }

  Future<List<MaintenanceResponse>> getMyMaintenances() async {
    try {
      final response = await apiClient.dio.get("/api/maintenances/my"); 

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => MaintenanceResponse.fromJson(e)).toList();
      } else {
        throw ApiException(
          "Error al obtener mis mantenimientos",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al obtener mis mantenimientos");
    }
  }

  Future<List<MaintenanceResponse>> getByBathroom(int bathroomId) async {
    try {
      final response = await apiClient.dio.get(
        "/api/maintenances/bathroom/$bathroomId", 
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((e) => MaintenanceResponse.fromJson(e)).toList();
      } else {
        throw ApiException(
          "Error al obtener mantenimientos por baño",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al obtener mantenimientos por baño");
    }
  }

  Future<MaintenanceResponse> getById(int id) async {
    try {
      final response = await apiClient.dio.get(
        "/api/maintenances/$id", 
      );

      if (response.statusCode == 200) {
        return MaintenanceResponse.fromJson(response.data);
      } else {
        throw ApiException(
          "Error al obtener mantenimiento",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al obtener mantenimiento");
    }
  }

  Future<MaintenanceResponse> create(MaintenanceRequest request) async {
    try {
      final response = await apiClient.dio.post(
        "/api/maintenances", 
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return MaintenanceResponse.fromJson(response.data);
      } else {
        throw ApiException(
          "Error al crear mantenimiento",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al crear mantenimiento");
    }
  }

  Future<MaintenanceResponse> update(int id, MaintenanceRequest request) async {
    try {
      final response = await apiClient.dio.put(
        "/api/maintenances/$id", 
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return MaintenanceResponse.fromJson(response.data);
      } else {
        throw ApiException(
          "Error al actualizar mantenimiento",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al actualizar mantenimiento");
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await apiClient.dio.delete(
        "/api/maintenances/$id", 
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          "Error al eliminar mantenimiento",
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException("Error al eliminar mantenimiento");
    }
  }
}