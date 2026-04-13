

import 'package:bathroom_vision/features/cleanings/data/cleaning_schedule_api.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_request.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_response.dart';

class CleaningScheduleRepository {
  final CleaningScheduleApi api;

  CleaningScheduleRepository(this.api);

  Future<List<CleaningScheduleResponse>> getAll() {
    return api.getAll();
  }

  Future<List<CleaningScheduleResponse>> getMySchedules() {
    return api.getMySchedules();
  }

  Future<List<CleaningScheduleResponse>> getByBathroom(int bathroomId) {
    return api.getByBathroom(bathroomId);
  }

  Future<CleaningScheduleResponse> getById(int id) {
    return api.getById(id);
  }

  Future<CleaningScheduleResponse> create(CleaningScheduleRequest request) {
    return api.create(request);
  }

  Future<CleaningScheduleResponse> update(int id,CleaningScheduleRequest request) {
    return api.update(id, request);
  }

  Future<void> delete(int id) {
    return api.delete(id);
  }
}