import 'package:bathroom_vision/features/bathrooms/models/bathroom_response.dart';
import 'package:bathroom_vision/shared/enums/cleaning_frecuency.dart';

class CleaningScheduleResponse {
  final int id;
  final BathroomResponse bathroom;
  final int userId;
  final String userName;
  final String startDate;
  final String endDate;
  final CleaningFrequency frequency;
  final String? daysOfWeek;
  final String startTime;
  final String endTime;

  CleaningScheduleResponse({
    required this.id,
    required this.bathroom,
    required this.userId,
    required this.userName,
    required this.startDate,
    required this.endDate,
    required this.frequency,
    this.daysOfWeek,
    required this.startTime,
    required this.endTime,
  });

  factory CleaningScheduleResponse.fromJson(Map<String, dynamic> json) {
    return CleaningScheduleResponse(
      id: json["id"],
      bathroom: BathroomResponse.fromJson(json["bathroom"]),
      userId: json["userId"],
      userName: json["userName"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      frequency: CleaningFrequency.values.firstWhere((e) => e.name == json["frequency"]),
      daysOfWeek: json["daysOfWeek"],
      startTime: json["startTime"],
      endTime: json["endTime"],
    );
  }
}