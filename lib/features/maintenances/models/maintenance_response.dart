import 'package:bathroom_vision/features/bathrooms/models/bathroom_response.dart';

class MaintenanceResponse {
  final int id;
  final BathroomResponse bathroom;
  final String technicianFullName;
  final String description;

  MaintenanceResponse({
    required this.id,
    required this.bathroom,
    required this.technicianFullName,
    required this.description,
  });

  factory MaintenanceResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceResponse(
      id: json["id"],
      bathroom: BathroomResponse.fromJson(json["bathroom"]),
      technicianFullName: json["technicianFullName"],
      description: json["description"],
    );
  }
}