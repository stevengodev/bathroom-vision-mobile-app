import 'package:json_annotation/json_annotation.dart';

part 'incident_statistics_model.g.dart';

@JsonSerializable()
class IncidentStatisticsModel {
  final String groupBy;
  final String sort;
  final List<IncidentStatisticsItemModel> items;

  IncidentStatisticsModel({
    required this.groupBy,
    required this.sort,
    required this.items,
  });

  factory IncidentStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$IncidentStatisticsModelFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentStatisticsModelToJson(this);
}

@JsonSerializable()
class IncidentStatisticsItemModel {
  final int? bathroomId;
  final String? blockName;
  final String? category;
  final int count;

  IncidentStatisticsItemModel({
    this.bathroomId,
    this.blockName,
    this.category,
    required this.count,
  });

  factory IncidentStatisticsItemModel.fromJson(Map<String, dynamic> json) =>
      _$IncidentStatisticsItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentStatisticsItemModelToJson(this);
}
