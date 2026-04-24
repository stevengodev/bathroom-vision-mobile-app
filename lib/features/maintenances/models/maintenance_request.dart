class MaintenanceRequest {
  final int bathroomId;
  final String technicianFullName;
  final String description;

  MaintenanceRequest({
    required this.bathroomId,
    required this.technicianFullName,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "bathroomId": bathroomId,
      "technicianFullName": technicianFullName,
      "description": description,
    };
  }
}