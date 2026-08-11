
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

  // ============================================================
  // CARGAR TODOS LOS MANTENIMIENTOS
  // ============================================================

  Future<void> loadMaintenances({String? status}) async {
    loading = true;
    selectedStatus = status;
    notifyListeners();

    try {
      maintenances = await repository.getAll(status: status);
    } catch (e) {
      debugPrint('Error cargando mantenimientos: $e');

      // IMPORTANTE:
      // Se vuelve a lanzar el error para que la pantalla
      // pueda manejarlo si es necesario.
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CARGAR MANTENIMIENTO POR ID
  // ============================================================

  Future<void> loadMaintenanceById(int id) async {
    loading = true;
    notifyListeners();

    try {
      selectedMaintenance = await repository.getById(id);
    } catch (e) {
      debugPrint(
        'Error cargando mantenimiento $id: $e',
      );

      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // CREAR MANTENIMIENTO
  // ============================================================

  Future<void> createMaintenance(
    MaintenanceRequest request,
  ) async {
    try {
      final maintenance = await repository.create(request);

      maintenances.add(maintenance);

      notifyListeners();
    } catch (e) {
      debugPrint(
        'Error creando mantenimiento: $e',
      );

      // IMPORTANTE:
      // NO nos quedamos con el error aquí.
      // Lo enviamos al formulario para mostrar el mensaje.
      rethrow;
    }
  }

  // ============================================================
  // ACTUALIZAR MANTENIMIENTO
  // ============================================================

  Future<void> updateMaintenance(
    int id,
    MaintenanceRequest request,
  ) async {
    try {
      final updated = await repository.update(
        id,
        request,
      );

      final index = maintenances.indexWhere(
        (m) => m.id == id,
      );

      if (index != -1) {
        maintenances[index] = updated;
      }

      notifyListeners();
    } catch (e) {
      debugPrint(
        'Error actualizando mantenimiento $id: $e',
      );

      // IMPORTANTE:
      // El formulario necesita recibir el error.
      rethrow;
    }
  }

  // ============================================================
  // ELIMINAR MANTENIMIENTO
  // ============================================================

  Future<void> deleteMaintenance(int id) async {
    try {
      await repository.delete(id);

      maintenances.removeWhere(
        (m) => m.id == id,
      );

      notifyListeners();
    } catch (e) {
      debugPrint(
        'Error eliminando mantenimiento $id: $e',
      );

      rethrow;
    }
  }

  // ============================================================
  // MIS MANTENIMIENTOS
  // ============================================================

  Future<void> loadMyMaintenances() async {
    loading = true;
    notifyListeners();

    try {
      maintenances =
          await repository.getMyMaintenances();
    } catch (e) {
      debugPrint(
        'Error cargando mis mantenimientos: $e',
      );

      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // ACTUALIZAR ESTADO
  // ============================================================

  Future<void> updateMaintenanceStatus(
    int id,
    String status,
  ) async {
    try {
      final updated =
          await repository.updateStatus(
        id,
        status,
      );

      final index = maintenances.indexWhere(
        (m) => m.id == id,
      );

      if (index != -1) {
        maintenances[index] = updated;
      }

      notifyListeners();
    } catch (e) {
      debugPrint(
        'Error actualizando estado del mantenimiento $id: $e',
      );

      rethrow;
    }
  }

  // ============================================================
  // VERIFICAR SI EXISTE UN MANTENIMIENTO EN EL MISMO HORARIO
  // ============================================================
  //
  // Esta validación compara:
  //
  // - mismo baño
  // - mismo año
  // - mismo mes
  // - mismo día
  // - misma hora
  // - mismo minuto
  //
  // Al editar, ignora el mantenimiento que se está editando.
  //
  // ============================================================

  bool isScheduleOccupied({
    required int bathroomId,
    required DateTime scheduledAt,
    int? excludeMaintenanceId,
  }) {
    return maintenances.any((maintenance) {
      // ----------------------------------------------------------
      // No comparar con el mismo mantenimiento cuando estamos
      // editando.
      // ----------------------------------------------------------

      if (excludeMaintenanceId != null &&
          maintenance.id == excludeMaintenanceId) {
        return false;
      }

      // ----------------------------------------------------------
      // Verificar que sea el mismo baño.
      // ----------------------------------------------------------

      if (maintenance.bathroom.id != bathroomId) {
        return false;
      }

      // ----------------------------------------------------------
      // Convertir la fecha existente.
      // ----------------------------------------------------------

      final existingDate =
          DateTime.tryParse(
        maintenance.scheduledAt,
      );

      if (existingDate == null) {
        return false;
      }

      // ----------------------------------------------------------
      // Comparar fecha y hora.
      // ----------------------------------------------------------

      return existingDate.year ==
              scheduledAt.year &&
          existingDate.month ==
              scheduledAt.month &&
          existingDate.day ==
              scheduledAt.day &&
          existingDate.hour ==
              scheduledAt.hour &&
          existingDate.minute ==
              scheduledAt.minute;
    });
  }
}