// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_statistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncidentStatisticsModel _$IncidentStatisticsModelFromJson(
  Map<String, dynamic> json,
) => IncidentStatisticsModel(
  groupBy: json['groupBy'] as String,
  sort: json['sort'] as String,
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => IncidentStatisticsItemModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$IncidentStatisticsModelToJson(
  IncidentStatisticsModel instance,
) => <String, dynamic>{
  'groupBy': instance.groupBy,
  'sort': instance.sort,
  'items': instance.items,
};

IncidentStatisticsItemModel _$IncidentStatisticsItemModelFromJson(
  Map<String, dynamic> json,
) => IncidentStatisticsItemModel(
  bathroomId: (json['bathroomId'] as num?)?.toInt(),
  blockName: json['blockName'] as String?,
  category: json['category'] as String?,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$IncidentStatisticsItemModelToJson(
  IncidentStatisticsItemModel instance,
) => <String, dynamic>{
  'bathroomId': instance.bathroomId,
  'blockName': instance.blockName,
  'category': instance.category,
  'count': instance.count,
};
