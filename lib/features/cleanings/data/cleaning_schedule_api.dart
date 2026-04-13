import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_request.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_response.dart';

class CleaningScheduleApi {
  final ApiClient apiClient;

  CleaningScheduleApi(this.apiClient);

  Future<List<CleaningScheduleResponse>> getAll() async {
    final response = await apiClient.dio.get("/api/schedules/cleaning");
    final List data = response.data;

    return data.map((e) => CleaningScheduleResponse.fromJson(e)).toList();
  }

  Future<List<CleaningScheduleResponse>> getMySchedules() async {
    final response = await apiClient.dio.get("/api/schedules/cleaning/me");
    final List data = response.data;

    return data.map((e) => CleaningScheduleResponse.fromJson(e)).toList();
  }

  Future<List<CleaningScheduleResponse>> getByBathroom(int bathroomId) async {
    final response = await apiClient.dio.get(
      "/api/schedules/cleaning/bathroom/$bathroomId",
    );

    final List data = response.data;
    return data.map((e) => CleaningScheduleResponse.fromJson(e)).toList();
  }

  Future<CleaningScheduleResponse> getById(int id) async {
    final response = await apiClient.dio.get(
      "/api/schedules/cleaning/$id",
    );

    return CleaningScheduleResponse.fromJson(response.data);
  }

  Future<CleaningScheduleResponse> create(CleaningScheduleRequest request) async {
    final response = await apiClient.dio.post(
      "/api/schedules/cleaning",
      data: request.toJson(),
    );

    return CleaningScheduleResponse.fromJson(response.data);
  }

  Future<CleaningScheduleResponse> update(int id, CleaningScheduleRequest request) async {
    final response = await apiClient.dio.put(
      "/api/schedules/cleaning/$id",
      data: request.toJson(),
    );

    return CleaningScheduleResponse.fromJson(response.data);
  }

  Future<void> delete(int id) async {
    await apiClient.dio.delete("/api/schedules/cleaning/$id");
  }
}