class IncidentMessageResponse {
  final int? id;
  final String code;
  final String description;

  const IncidentMessageResponse({
    required this.id,
    required this.code,
    required this.description,
  });

  factory IncidentMessageResponse.fromJson(Map<String, dynamic> json) {
    return IncidentMessageResponse(
      id: json["id"],
      code: json["code"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "description": description,
    };
  }
}