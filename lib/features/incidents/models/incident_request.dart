class IncidentRequest {
  final String email;
  final List<int> incidentMessageIds;
  final int bathroomId;

  const IncidentRequest({
    required this.email,
    required this.incidentMessageIds,
    required this.bathroomId,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "incidentMessageIds": incidentMessageIds,
      "bathroomId": bathroomId,
    };
  }

  factory IncidentRequest.fromJson(Map<String, dynamic> json) {
    return IncidentRequest(
      email: json["email"],
      incidentMessageIds: List<int>.from(json["incidentMessageIds"]),
      bathroomId: json["bathroomId"],
    );
  }
}