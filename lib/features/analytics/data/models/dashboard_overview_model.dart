import 'package:json_annotation/json_annotation.dart';

part 'dashboard_overview_model.g.dart';

@JsonSerializable()
class DashboardOverviewModel {
  final int totalBathrooms;
  final int availableBathrooms;
  final int occupiedBathrooms;
  final int maintenanceBathrooms;
  final int activeIncidents;
  final int openMaintenances;
  final int closedMaintenances;

  DashboardOverviewModel({
    required this.totalBathrooms,
    required this.availableBathrooms,
    required this.occupiedBathrooms,
    required this.maintenanceBathrooms,
    required this.activeIncidents,
    required this.openMaintenances,
    required this.closedMaintenances,
  });

  factory DashboardOverviewModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardOverviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardOverviewModelToJson(this);
}
