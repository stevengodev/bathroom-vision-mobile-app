import 'package:bathroom_vision/shared/enums/cleaning_frecuency.dart';

class CleaningScheduleResponse {
  final int id;
  final int bathroomId;
  final String startDate;
  final String endDate;
  final CleaningFrequency frequency;
  final String? daysOfWeek;
  final String startTime;
  final String endTime;

  CleaningScheduleResponse({
    required this.id,
    required this.bathroomId,
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
      bathroomId: json["bathroomId"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      frequency: CleaningFrequency.values.firstWhere((e) => e.name == json["frequency"]),
      daysOfWeek: json["daysOfWeek"],
      startTime: json["startTime"],
      endTime: json["endTime"],
    );
  }
}