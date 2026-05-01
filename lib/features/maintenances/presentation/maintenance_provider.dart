import 'package:flutter/material.dart';
import 'package:bathroom_vision/features/maintenances/data/maintenance_repository.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_request.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';

class MaintenanceProvider extends ChangeNotifier {
  final MaintenanceRepository repository;

  MaintenanceProvider(this.repository);

  List<MaintenanceResponse> maintenances = [];

  MaintenanceResponse? selectedMaintenance;

  String? selectedStatus;

  bool loading = false;

  Future<void> loadMaintenances({String? status}) async {
    loading = true;
    selectedStatus = status;
    notifyListeners();

    try {
      maintenances = await repository.getAll(status: status);
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadMaintenanceById(int id) async {
    loading = true;
    notifyListeners();

    try {
      selectedMaintenance = await repository.getById(id);
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> createMaintenance(MaintenanceRequest request) async {
    try {
      final maintenance = await repository.create(request);

      maintenances.add(maintenance);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateMaintenance(int id, MaintenanceRequest request) async {
    try {
      final updated = await repository.update(id, request);

      final index = maintenances.indexWhere((m) => m.id == id);

      if (index != -1) {
        maintenances[index] = updated;
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteMaintenance(int id) async {
    try {
      await repository.delete(id);

      maintenances.removeWhere((m) => m.id == id);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadMyMaintenances() async {
    loading = true;
    notifyListeners();

    try {
      maintenances = await repository.getMyMaintenances();
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> updateMaintenanceStatus(int id, String status) async {
    try {
      final updated = await repository.updateStatus(id, status);

      final index = maintenances.indexWhere((m) => m.id == id);

      if (index != -1) {
        maintenances[index] = updated;
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
