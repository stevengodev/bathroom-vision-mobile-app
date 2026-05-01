import 'package:bathroom_vision/features/maintenances/data/maintenance_api.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_request.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';

class MaintenanceRepository {
  final MaintenanceApi api;

  MaintenanceRepository(this.api);

  Future<List<MaintenanceResponse>> getAll({String? status}) {
    return api.getAll(status: status);
  }

  Future<List<MaintenanceResponse>> getMyMaintenances() {
    return api.getMyMaintenances();
  }

  Future<List<MaintenanceResponse>> getByBathroom(int bathroomId) {
    return api.getByBathroom(bathroomId);
  }

  Future<MaintenanceResponse> getById(int id) {
    return api.getById(id);
  }

  Future<MaintenanceResponse> create(MaintenanceRequest request) {
    return api.create(request);
  }

  Future<MaintenanceResponse> update(int id, MaintenanceRequest request) {
    return api.update(id, request);
  }

  Future<void> delete(int id) {
    return api.delete(id);
  }

  Future<MaintenanceResponse> updateStatus(int id, String status) {
    return api.updateStatus(id, status);
  }
}
