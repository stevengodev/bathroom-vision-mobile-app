// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardOverviewModel _$DashboardOverviewModelFromJson(
  Map<String, dynamic> json,
) => DashboardOverviewModel(
  totalBathrooms: (json['totalBathrooms'] as num).toInt(),
  availableBathrooms: (json['availableBathrooms'] as num).toInt(),
  occupiedBathrooms: (json['occupiedBathrooms'] as num).toInt(),
  maintenanceBathrooms: (json['maintenanceBathrooms'] as num).toInt(),
  activeIncidents: (json['activeIncidents'] as num).toInt(),
  openMaintenances: (json['openMaintenances'] as num).toInt(),
  closedMaintenances: (json['closedMaintenances'] as num).toInt(),
);

Map<String, dynamic> _$DashboardOverviewModelToJson(
  DashboardOverviewModel instance,
) => <String, dynamic>{
  'totalBathrooms': instance.totalBathrooms,
  'availableBathrooms': instance.availableBathrooms,
  'occupiedBathrooms': instance.occupiedBathrooms,
  'maintenanceBathrooms': instance.maintenanceBathrooms,
  'activeIncidents': instance.activeIncidents,
  'openMaintenances': instance.openMaintenances,
  'closedMaintenances': instance.closedMaintenances,
};
