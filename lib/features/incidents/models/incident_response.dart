import 'package:bathroom_vision/features/incidents/models/affected_bathroom.dart';
import 'package:bathroom_vision/features/incidents/models/incident_message_response.dart';
import 'package:bathroom_vision/features/incidents/models/reporter_info.dart';

class IncidentResponse {
  final int? id;
  final ReporterInfo reporter;
  final IncidentMessageResponse incidentMessage;
  final AffectedBathroom bathroom;
  final String status;
  final DateTime reportedAt;
  final DateTime? resolvedAt;

  const IncidentResponse({
    required this.id,
    required this.reporter,
    required this.incidentMessage,
    required this.bathroom,
    required this.status,
    required this.reportedAt,
    required this.resolvedAt,
  });

  factory IncidentResponse.fromJson(Map<String, dynamic> json) {
    return IncidentResponse(
      id: json["id"],
      reporter: ReporterInfo.fromJson(json["reporter"]),
      incidentMessage: IncidentMessageResponse.fromJson(
        json["incidentMessage"],
      ),
      bathroom: AffectedBathroom.fromJson(json["bathroom"]),
      status: json["status"],
      reportedAt: DateTime.parse(json["reportedAt"]),
      resolvedAt: json["resolvedAt"] != null
          ? DateTime.parse(json["resolvedAt"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "reporter": reporter.toJson(),
      "incidentMessage": incidentMessage.toJson(),
      "bathroom": bathroom.toJson(),
      "status": status,
      "reportedAt": reportedAt.toIso8601String(),
      "resolvedAt": resolvedAt?.toIso8601String(),
    };
  }

  IncidentResponse copyWith({
    int? id,
    ReporterInfo? reporter,
    IncidentMessageResponse? incidentMessage,
    AffectedBathroom? bathroom,
    String? status,
    DateTime? reportedAt,
    DateTime? resolvedAt,
  }) {
    return IncidentResponse(
      id: id ?? this.id,
      reporter: reporter ?? this.reporter,
      incidentMessage: incidentMessage ?? this.incidentMessage,
      bathroom: bathroom ?? this.bathroom,
      status: status ?? this.status,
      reportedAt: reportedAt ?? this.reportedAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }
}

