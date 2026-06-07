import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/core/errors/api_exception.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_request.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';

class MaintenanceApi {
  final ApiClient apiClient;

  MaintenanceApi(this.apiClient);

  Future<List<MaintenanceResponse>> getAll({String? status}) async {
    dynamic queryParameters;

    if (status != null) {
      queryParameters = {"status": status};
    }

    try {
      final response = await apiClient.dio.get(
        "/api/maintenances",
        queryParameters: queryParameters,
      );

      final List data = response.data;

      return data.map((e) => MaintenanceResponse.fromJson(e)).toList();
    } catch (e) {
      throw ApiException("Error al obtener mantenimientos");
    }
  }

  Future<List<MaintenanceResponse>> getMyMaintenances() async {
    try {
      final response = await apiClient.dio.get("/api/maintenances/my");

      final List data = response.data;
      return data.map((e) => MaintenanceResponse.fromJson(e)).toList();
    } catch (e) {
      throw ApiException("Error al obtener mis mantenimientos");
    }
  }

  Future<List<MaintenanceResponse>> getByBathroom(int bathroomId) async {
    try {
      final response = await apiClient.dio.get(
        "/api/maintenances/bathroom/$bathroomId",
      );

      final List data = response.data;
      return data.map((e) => MaintenanceResponse.fromJson(e)).toList();
    } catch (e) {
      throw ApiException("Error al obtener mantenimientos por baño");
    }
  }

  Future<MaintenanceResponse> getById(int id) async {
    try {
      final response = await apiClient.dio.get("/api/maintenances/$id");

      return MaintenanceResponse.fromJson(response.data);
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

      return MaintenanceResponse.fromJson(response.data);
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

      return MaintenanceResponse.fromJson(response.data);
    } catch (e) {
      throw ApiException("Error al actualizar mantenimiento");
    }
  }

  Future<void> delete(int id) async {
    try {
      await apiClient.dio.delete("/api/maintenances/$id");
    } catch (e) {
      throw ApiException("Error al eliminar mantenimiento");
    }
  }

  Future<MaintenanceResponse> updateStatus(int id, String status) async {
    try {
      final response = await apiClient.dio.patch(
        "/api/maintenances/$id/status",
        queryParameters: {"status": status},
      );

      return MaintenanceResponse.fromJson(response.data);
    } catch (e) {
      throw ApiException("Error al actualizar estado del mantenimiento");
    }
  }
}
