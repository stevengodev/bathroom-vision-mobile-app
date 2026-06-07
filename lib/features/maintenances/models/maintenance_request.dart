class MaintenanceRequest {
  final int bathroomId;
  final String technicianFullName;
  final String description;
  final String scheduledAt;

  MaintenanceRequest({
    required this.bathroomId,
    required this.technicianFullName,
    required this.description,
    required this.scheduledAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "bathroomId": bathroomId,
      "technicianFullName": technicianFullName,
      "description": description,
      "scheduledAt": scheduledAt,
    };
  }
}