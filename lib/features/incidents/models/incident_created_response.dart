class IncidentCreatedResponse {
  final List<int> incidentIds;
  final String status;
  final DateTime reportedAt;

  const IncidentCreatedResponse({
    required this.incidentIds,
    required this.status,
    required this.reportedAt,
  });

  factory IncidentCreatedResponse.fromJson(Map<String, dynamic> json) {
    return IncidentCreatedResponse(
      incidentIds: List<int>.from(json["incidentIds"]),
      status: json["status"],
      reportedAt: DateTime.parse(json["reportedAt"]),
    );
  }
}