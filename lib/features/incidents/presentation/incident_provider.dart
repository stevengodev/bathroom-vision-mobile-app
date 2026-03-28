import 'package:bathroom_vision/shared/enums/incident_status.dart';
import 'package:flutter/material.dart';
import 'package:bathroom_vision/features/incidents/data/incident_repository.dart';
import 'package:bathroom_vision/features/incidents/models/incident_request.dart';
import 'package:bathroom_vision/features/incidents/models/incident_response.dart';
import 'package:bathroom_vision/features/incidents/models/incident_message_response.dart';

class IncidentProvider extends ChangeNotifier {
  final IncidentRepository repository;

  IncidentProvider(this.repository);

  List<IncidentResponse> incidents = [];
  List<IncidentMessageResponse> messages = [];

  IncidentResponse? selectedIncident;

  bool loading = false;

  Future<void> loadAllIncidents(IncidentStatus status) async {
    loading = true;
    notifyListeners();

    try {
      incidents = await repository.getAllIncidents(status);
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadIncidentsByBathroom(int bathroomId) async {
    loading = true;
    notifyListeners();

    try {
      incidents = await repository.getIncidentByBathroomId(bathroomId);
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadMyIncidents() async {
    loading = true;
    notifyListeners();

    try {
      incidents = await repository.getIncidentByUser();
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadIncidentById(int id) async {
    loading = true;
    notifyListeners();

    try {
      selectedIncident = await repository.getIncidentById(id);
    } catch (e) {
      print(e);
    }

    loading = false;
    notifyListeners();
  }

  Future<void> loadMessages() async {
    try {
      messages = await repository.getIncidentMessages();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> createIncident(IncidentRequest request) async {
    try {
      await repository.createIncident(request);
      await loadIncidentsByBathroom(request.bathroomId);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateIncident(int id, IncidentRequest request) async {
    try {
      final updated = await repository.updateIncident(id, request);

      final index = incidents.indexWhere((i) => i.id == id);
      if (index != -1) {
        incidents[index] = updated;
      }

      if (selectedIncident?.id == id) {
        selectedIncident = updated;
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> resolveIncident(int incidentMessageId, int bathroomId) async {
    try {
      await repository.updateStatusIncident(incidentMessageId, bathroomId);

      final index = incidents.indexWhere((i) => i.incidentMessage.id == incidentMessageId);
      if (index != -1) {
        incidents[index] = incidents[index].copyWith(status: "RESOLVED");
      }

      if (selectedIncident?.incidentMessage.id == incidentMessageId) {
        selectedIncident =
            selectedIncident!.copyWith(status: "RESOLVED");
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}