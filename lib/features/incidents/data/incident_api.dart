import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/features/incidents/models/incident_created_response.dart';
import 'package:bathroom_vision/features/incidents/models/incident_message_response.dart';
import 'package:bathroom_vision/features/incidents/models/incident_request.dart';
import 'package:bathroom_vision/features/incidents/models/incident_response.dart';
import 'package:bathroom_vision/shared/enums/incident_status.dart';

class IncidentApi {
  final ApiClient apiClient;

  IncidentApi(this.apiClient);

  Future<List<IncidentMessageResponse>> getIncidentMessages() async {
    final response = await apiClient.dio.get("/api/incidents/messages");

    return (response.data as List)
        .map((json) => IncidentMessageResponse.fromJson(json))
        .toList();
  }

  Future<List<IncidentResponse>> getAllIncidents(IncidentStatus status) async {
    final response = await apiClient.dio.get("/api/incidents", queryParameters: {
      "status": status.name,
    });
    final List data = response.data;
    return data.map((e) => IncidentResponse.fromJson(e)).toList();
  }

  Future<IncidentResponse> getIncidentById(int id) async {
    final response = await apiClient.dio.get("/api/incidents/$id");
    return IncidentResponse.fromJson(response.data);
  }

  Future<List<IncidentResponse>> getIncidentByBathroomId(int bathroomId) async {
    final response = await apiClient.dio.get(
      "/api/incidents/bathroom/$bathroomId",
    );
    final List data = response.data;
    return data.map((e) => IncidentResponse.fromJson(e)).toList();
  }

  Future<List<IncidentResponse>> getIncidentByUser() async {
    final response = await apiClient.dio.get("/api/incidents/me");
    final List data = response.data;
    return data.map((e) => IncidentResponse.fromJson(e)).toList();
  }

  Future<IncidentCreatedResponse> createIncident(
    IncidentRequest incidentRequest,
  ) async {
    final response = await apiClient.dio.post(
      "/api/incidents",
      data: incidentRequest.toJson(),
    );

    return IncidentCreatedResponse.fromJson(response.data);
  }

  Future<IncidentResponse> updateIncident(
    int id,
    IncidentRequest incidentRequest,
  ) async {
    final response = await apiClient.dio.put(
      "/api/incidents/$id",
      data: incidentRequest.toJson(),
    );

    return IncidentResponse.fromJson(response.data);
  }

  //Se usa para resolver una incidencia
  Future<int> updateStatusIncident(int messageId, int bathroomId) async {
    final response = await apiClient.dio.patch(
      "/api/incidents/$messageId/status",
      queryParameters: {"bathroomId": bathroomId},
    );

    return response.data;
  }
}
