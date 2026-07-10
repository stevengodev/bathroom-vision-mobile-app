import 'package:bathroom_vision/core/api/api_client.dart';
import 'package:bathroom_vision/features/analytics/data/models/dashboard_overview_model.dart';
import 'package:bathroom_vision/features/analytics/data/models/incident_statistics_model.dart';
import 'package:bathroom_vision/features/analytics/data/models/maintenance_statistics_model.dart';

class AnalyticsRemoteDataSource {
  final ApiClient apiClient;

  AnalyticsRemoteDataSource(this.apiClient);

  Future<DashboardOverviewModel> getDashboardOverview() async {
    final response = await apiClient.dio.get('/api/dashboard/overview');
    return DashboardOverviewModel.fromJson(response.data);
  }

  Future<IncidentStatisticsModel> getIncidentStatistics({
    String groupBy = 'bathroom',
    String sort = 'desc',
  }) async {
    final response = await apiClient.dio.get(
      '/api/statistics/incidents',
      queryParameters: {
        'groupBy': groupBy,
        'sort': sort,
      },
    );
    return IncidentStatisticsModel.fromJson(response.data);
  }

  Future<MaintenanceStatisticsModel> getMaintenanceStatistics({
    String? status,
    int? bathroomId,
    String? startDate,
    String? endDate,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (status != null) queryParams['status'] = status;
    if (bathroomId != null) queryParams['bathroomId'] = bathroomId;
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;

    final response = await apiClient.dio.get(
      '/api/statistics/maintenance',
      queryParameters: queryParams,
    );
    return MaintenanceStatisticsModel.fromJson(response.data);
  }
}
