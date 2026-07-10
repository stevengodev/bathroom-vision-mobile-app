// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceStatisticsModel _$MaintenanceStatisticsModelFromJson(
  Map<String, dynamic> json,
) => MaintenanceStatisticsModel(
  status: json['status'] as String?,
  bathroomId: (json['bathroomId'] as num?)?.toInt(),
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  openCount: (json['openCount'] as num).toInt(),
  closedCount: (json['closedCount'] as num).toInt(),
  history: (json['history'] as List<dynamic>)
      .map(
        (e) => MaintenanceHistoryItemModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$MaintenanceStatisticsModelToJson(
  MaintenanceStatisticsModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'bathroomId': instance.bathroomId,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'openCount': instance.openCount,
  'closedCount': instance.closedCount,
  'history': instance.history,
};

MaintenanceHistoryItemModel _$MaintenanceHistoryItemModelFromJson(
  Map<String, dynamic> json,
) => MaintenanceHistoryItemModel(
  id: (json['id'] as num).toInt(),
  bathroomId: (json['bathroomId'] as num?)?.toInt(),
  blockName: json['blockName'] as String?,
  status: json['status'] as String,
  reportedAt: json['reportedAt'] as String?,
  resolvedAt: json['resolvedAt'] as String?,
);

Map<String, dynamic> _$MaintenanceHistoryItemModelToJson(
  MaintenanceHistoryItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'bathroomId': instance.bathroomId,
  'blockName': instance.blockName,
  'status': instance.status,
  'reportedAt': instance.reportedAt,
  'resolvedAt': instance.resolvedAt,
};
