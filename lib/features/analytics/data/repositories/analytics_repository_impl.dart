import 'package:bathroom_vision/features/analytics/data/datasources/analytics_remote_datasource.dart';
import 'package:bathroom_vision/features/analytics/data/models/dashboard_overview_model.dart';
import 'package:bathroom_vision/features/analytics/data/models/incident_statistics_model.dart';
import 'package:bathroom_vision/features/analytics/data/models/maintenance_statistics_model.dart';
import 'package:bathroom_vision/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl(this.remoteDataSource);

  @override
  Future<DashboardOverviewModel> getDashboardOverview() {
    return remoteDataSource.getDashboardOverview();
  }

  @override
  Future<IncidentStatisticsModel> getIncidentStatistics({
    String groupBy = 'bathroom',
    String sort = 'desc',
  }) {
    return remoteDataSource.getIncidentStatistics(groupBy: groupBy, sort: sort);
  }

  @override
  Future<MaintenanceStatisticsModel> getMaintenanceStatistics({
    String? status,
    int? bathroomId,
    String? startDate,
    String? endDate,
  }) {
    return remoteDataSource.getMaintenanceStatistics(
      status: status,
      bathroomId: bathroomId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
