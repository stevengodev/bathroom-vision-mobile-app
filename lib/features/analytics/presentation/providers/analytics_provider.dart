import 'package:bathroom_vision/features/analytics/data/models/dashboard_overview_model.dart';
import 'package:bathroom_vision/features/analytics/data/models/incident_statistics_model.dart';
import 'package:bathroom_vision/features/analytics/data/models/maintenance_statistics_model.dart';
import 'package:bathroom_vision/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:flutter/material.dart';

class AnalyticsProvider extends ChangeNotifier {
  final AnalyticsRepository repository;

  AnalyticsProvider(this.repository);

  bool isLoading = false;
  String? errorMessage;

  DashboardOverviewModel? dashboardData;
  IncidentStatisticsModel? incidentData;
  MaintenanceStatisticsModel? maintenanceData;

  String incidentGroupBy = 'bathroom';
  String? maintenanceStatus;
  int? maintenanceBathroomId;
  DateTime? maintenanceStartDate;
  DateTime? maintenanceEndDate;

  void setIncidentGroupBy(String value) {
    incidentGroupBy = value;
    loadIncidentData();
  }

  void setMaintenanceFilters({
    String? status,
    int? bathroomId,
    DateTime? startDate,
    DateTime? endDate,
    bool clearBathroomId = false,
  }) {
    if (status != null) maintenanceStatus = status == 'all' ? null : status;
    if (bathroomId != null) maintenanceBathroomId = bathroomId;
    if (clearBathroomId) maintenanceBathroomId = null;
    if (startDate != null) maintenanceStartDate = startDate;
    if (endDate != null) maintenanceEndDate = endDate;
    loadMaintenanceData();
  }

  void clearMaintenanceFilters() {
    maintenanceStatus = null;
    maintenanceBathroomId = null;
    maintenanceStartDate = null;
    maintenanceEndDate = null;
    loadMaintenanceData();
  }

  Future<void> loadMaintenanceData() async {
    try {
      maintenanceData = await repository.getMaintenanceStatistics(
        status: maintenanceStatus,
        bathroomId: maintenanceBathroomId,
        startDate: maintenanceStartDate?.toIso8601String().split('T')[0],
        endDate: maintenanceEndDate?.toIso8601String().split('T')[0],
      );
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadIncidentData() async {
    try {
      incidentData = await repository.getIncidentStatistics(groupBy: incidentGroupBy);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadAnalyticsData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final futures = await Future.wait([
        repository.getDashboardOverview(),
        repository.getIncidentStatistics(groupBy: incidentGroupBy),
        repository.getMaintenanceStatistics(
          status: maintenanceStatus,
          bathroomId: maintenanceBathroomId,
          startDate: maintenanceStartDate?.toIso8601String().split('T')[0],
          endDate: maintenanceEndDate?.toIso8601String().split('T')[0],
        ),
      ]);

      dashboardData = futures[0] as DashboardOverviewModel;
      incidentData = futures[1] as IncidentStatisticsModel;
      maintenanceData = futures[2] as MaintenanceStatisticsModel;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
