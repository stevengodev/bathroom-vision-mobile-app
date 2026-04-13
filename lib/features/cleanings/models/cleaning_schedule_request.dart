import 'package:bathroom_vision/shared/enums/cleaning_frecuency.dart';

class CleaningScheduleRequest {
  final int bathroomId;
  final int userId;
  final String startDate; // YYYY-MM-DD
  final String endDate;
  final CleaningFrequency frequency; // DAILY, WEEKLY,
  final String? daysOfWeek; // MO,TU,...
  final String startTime; // HH:mm:ss
  final String endTime;

  CleaningScheduleRequest({
    required this.bathroomId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.frequency,
    this.daysOfWeek,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "bathroomId": bathroomId,
      "userId": userId,
      "startDate": startDate,
      "endDate": endDate,
      "frequency": frequency.name,
      "daysOfWeek": daysOfWeek,
      "startTime": startTime,
      "endTime": endTime,
    };
  }
}