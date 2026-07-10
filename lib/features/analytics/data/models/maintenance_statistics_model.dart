import 'package:json_annotation/json_annotation.dart';

part 'maintenance_statistics_model.g.dart';

@JsonSerializable()
class MaintenanceStatisticsModel {
  final String? status;
  final int? bathroomId;
  final String? startDate;
  final String? endDate;
  final int openCount;
  final int closedCount;
  final List<MaintenanceHistoryItemModel> history;

  MaintenanceStatisticsModel({
    this.status,
    this.bathroomId,
    this.startDate,
    this.endDate,
    required this.openCount,
    required this.closedCount,
    required this.history,
  });

  factory MaintenanceStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceStatisticsModelToJson(this);
}

@JsonSerializable()
class MaintenanceHistoryItemModel {
  final int id;
  final int? bathroomId;
  final String? blockName;
  final String status;
  final String? reportedAt;
  final String? resolvedAt;

  MaintenanceHistoryItemModel({
    required this.id,
    this.bathroomId,
    this.blockName,
    required this.status,
    this.reportedAt,
    this.resolvedAt,
  });

  factory MaintenanceHistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceHistoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceHistoryItemModelToJson(this);
}
