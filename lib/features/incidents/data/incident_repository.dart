import 'package:bathroom_vision/features/incidents/data/incident_api.dart';
import 'package:bathroom_vision/features/incidents/models/incident_created_response.dart';
import 'package:bathroom_vision/features/incidents/models/incident_message_response.dart';
import 'package:bathroom_vision/features/incidents/models/incident_request.dart';
import 'package:bathroom_vision/features/incidents/models/incident_response.dart';
import 'package:bathroom_vision/shared/enums/incident_message_category.dart';
import 'package:bathroom_vision/shared/enums/incident_status.dart';

class IncidentRepository {
  final IncidentApi api;

  IncidentRepository(this.api);

  Future<List<IncidentMessageResponse>> getIncidentMessages() {
    return api.getIncidentMessages();
  }

  Future<List<IncidentResponse>> getAllIncidents(IncidentStatus status, {IncidentMessageCategory? category}) {
    return api.getAllIncidents(status: status, category: category);
  }

  Future<IncidentResponse> getIncidentById(int id) {
    return api.getIncidentById(id);
  }

  Future<List<IncidentResponse>> getIncidentByBathroomId(int bathroomId) {
    return api.getIncidentByBathroomId(bathroomId);
  }

  Future<List<IncidentResponse>> getIncidentByUser() {
    return api.getIncidentByUser();
  }

  Future<IncidentCreatedResponse> createIncident(IncidentRequest request) {
    return api.createIncident(request);
  }

  Future<IncidentResponse> updateIncident(int id, IncidentRequest request) {
    return api.updateIncident(id, request);
  }

  Future<int> updateStatusIncident(int messageId, int bathroomId) {
    return api.updateStatusIncident(messageId, bathroomId);
  }
}