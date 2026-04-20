import 'package:bathroom_vision/features/cleanings/data/cleaning_schedule_repository.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_request.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_response.dart';
import 'package:bathroom_vision/core/errors/api_exception.dart';
import 'package:flutter/material.dart';

class CleaningScheduleProvider extends ChangeNotifier {
  final CleaningScheduleRepository repository;

  CleaningScheduleProvider(this.repository);

  List<CleaningScheduleResponse> schedules = [];
  CleaningScheduleResponse? selectedSchedule;

  bool loading = false;
  String? error;

  Future<void> loadSchedules() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      schedules = await repository.getAll();
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Error inesperado";
    }

    loading = false;
    notifyListeners();
  }

  Future<void> create(CleaningScheduleRequest request) async {
    try {
      final newSchedule = await repository.create(request);
      schedules.add(newSchedule);
      notifyListeners();
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Error inesperado";
    }
  }

  Future<void> update(int id, CleaningScheduleRequest request) async {
    try {
      final updated = await repository.update(id, request);

      final index = schedules.indexWhere((s) => s.id == id);
      if (index != -1) {
        schedules[index] = updated;
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
      schedules.removeWhere((s) => s.id == id);
      notifyListeners();
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = "Error inesperado";
    }
  }
}