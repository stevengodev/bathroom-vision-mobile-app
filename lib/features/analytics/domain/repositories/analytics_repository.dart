import 'package:bathroom_vision/features/analytics/data/models/dashboard_overview_model.dart';
import 'package:bathroom_vision/features/analytics/data/models/incident_statistics_model.dart';
import 'package:bathroom_vision/features/analytics/data/models/maintenance_statistics_model.dart';

abstract class AnalyticsRepository {
  Future<DashboardOverviewModel> getDashboardOverview();
  
  Future<IncidentStatisticsModel> getIncidentStatistics({
    String groupBy = 'bathroom',
    String sort = 'desc',
  });

  Future<MaintenanceStatisticsModel> getMaintenanceStatistics({
    String? status,
    int? bathroomId,
    String? startDate,
    String? endDate,
  });
}
