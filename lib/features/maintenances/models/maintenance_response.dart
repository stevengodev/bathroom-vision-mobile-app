import 'package:bathroom_vision/features/bathrooms/models/bathroom_response.dart';

class MaintenanceResponse {
  final int id;
  final BathroomResponse bathroom;
  final String technicianFullName;
  final String description;
  final String status;

  MaintenanceResponse({
    required this.id,
    required this.bathroom,
    required this.technicianFullName,
    required this.description,
    required this.status,
  });

  factory MaintenanceResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceResponse(
      id: json["id"],
      bathroom: BathroomResponse.fromJson(json["bathroom"]),
      technicianFullName: json["technicianFullName"],
      description: json["description"],
      status: json["status"],
    );
  }
}