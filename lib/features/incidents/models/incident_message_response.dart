class IncidentMessageResponse {
  final int? id;
  final String code;
  final String description;
  final String category;

  const IncidentMessageResponse({
    required this.id,
    required this.code,
    required this.description,
    required this.category,
  });

  factory IncidentMessageResponse.fromJson(Map<String, dynamic> json) {
    return IncidentMessageResponse(
      id: json["id"],
      code: json["code"],
      description: json["description"],
      category: json["category"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "code": code,
      "description": description,
      "category": category,
    };
  }
}