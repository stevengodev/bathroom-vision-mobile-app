import 'package:bathroom_vision/features/maintenances/data/maintenance_repository.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_request.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';
import 'package:bathroom_vision/core/errors/api_exception.dart';
import 'package:flutter/material.dart';

class MaintenanceProvider extends ChangeNotifier {
  final MaintenanceRepository repository;

  MaintenanceProvider(this.repository);

  List<MaintenanceResponse> maintenances = [];
  MaintenanceResponse? selectedMaintenance;

  bool loading = false;
  String? error;

  Future<void> loadMaintenances() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      maintenances = await repository.getAll();
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Error inesperado";
    }

    loading = false;
    notifyListeners();
  }

  Future<void> create(MaintenanceRequest request) async {
    try {
      final newMaintenance = await repository.create(request);
      maintenances.add(newMaintenance);
      notifyListeners();
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Error inesperado";
    }
  }

  Future<void> update(int id, MaintenanceRequest request) async {
    try {
      final updated = await repository.update(id, request);

      final index = maintenances.indexWhere((m) => m.id == id);
      if (index != -1) {
        maintenances[index] = updated;
      }

      notifyListeners();
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Error inesperado";
    }
  }

  Future<void> delete(int id) async {
    try {
      await repository.delete(id);
      maintenances.removeWhere((m) => m.id == id);
      notifyListeners();
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Error inesperado";
    }
  }

  Future<void> loadMaintenanceById(int id) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      selectedMaintenance = await repository.getById(id);
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Error inesperado";
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadMyMaintenances() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      maintenances = await repository.getMyMaintenances();
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Error inesperado";
    }

    loading = false;
    notifyListeners();
  }
}