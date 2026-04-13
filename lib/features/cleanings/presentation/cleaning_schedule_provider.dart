import 'package:bathroom_vision/features/cleanings/data/cleaning_schedule_repository.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_request.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_response.dart';
import 'package:flutter/material.dart';

class CleaningScheduleProvider extends ChangeNotifier {
  final CleaningScheduleRepository repository;

  CleaningScheduleProvider(this.repository);

  List<CleaningScheduleResponse> schedules = [];
  CleaningScheduleResponse? selectedSchedule;

  bool loading = false;

  Future<void> loadSchedules() async {
    loading = true;
    notifyListeners();

    try {
      schedules = await repository.getAll();
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadMySchedules() async {
    loading = true;
    notifyListeners();

    try {
      schedules = await repository.getMySchedules();
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadByBathroom(int bathroomId) async {
    loading = true;
    notifyListeners();

    try {
      schedules = await repository.getByBathroom(bathroomId);
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadById(int id) async {
    loading = true;
    notifyListeners();

    try {
      selectedSchedule = await repository.getById(id);
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> create(CleaningScheduleRequest request) async {
    try {
      final newSchedule = await repository.create(request);
      schedules.add(newSchedule);
      notifyListeners();
    } catch (e) {
      print(e);
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
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(int id) async {
    try {
      await repository.delete(id);
      schedules.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}