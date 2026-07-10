import 'package:bathroom_vision/features/analytics/presentation/providers/analytics_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  String? _pendingMaintenanceStatus = 'all';
  int? _pendingMaintenanceBathroomId;
  DateTime? _pendingMaintenanceStartDate;
  DateTime? _pendingMaintenanceEndDate;
  final TextEditingController _bathroomIdController = TextEditingController();

  @override
  void dispose() {
    _bathroomIdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsProvider>().loadAnalyticsData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Analítica de uso'),
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Resumen'),
              Tab(text: 'Incidencias'),
              Tab(text: 'Mantenimiento'),
            ],
          ),
        ),
        body: Consumer<AnalyticsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text('Error: \${provider.errorMessage}'),
                    TextButton(
                      onPressed: () => provider.loadAnalyticsData(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            if (provider.dashboardData == null) {
              return const Center(child: Text('No hay datos disponibles.'));
            }

            return RefreshIndicator(
              onRefresh: () => provider.loadAnalyticsData(),
              child: TabBarView(
                children: [
                  // Pestaña 1: Resumen
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Resumen General'),
                        _buildOverviewCards(provider.dashboardData!),
                      ],
                    ),
                  ),
                  // Pestaña 2: Incidencias
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Incidencias'),
                        _buildIncidentFilter(provider),
                        const SizedBox(height: 12),
                        if (provider.incidentData != null && provider.incidentData!.items.isNotEmpty)
                          _buildIncidentBarChart(provider.incidentData!)
                        else
                          const Text('No hay datos de incidencias.'),
                      ],
                    ),
                  ),
                  // Pestaña 3: Mantenimientos
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Mantenimientos'),
                        _buildMaintenanceFilters(provider, context),
                        const SizedBox(height: 12),
                        if (provider.maintenanceData != null)
                          _buildMaintenancePieChart(provider.maintenanceData!)
                        else
                          const Text('No hay datos de mantenimiento.'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }

  Widget _buildOverviewCards(dynamic dashboardData) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.25,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard('Total Baños', dashboardData.totalBathrooms.toString(), Colors.blue, Icons.bathroom),
        _buildStatCard('Disponibles', dashboardData.availableBathrooms.toString(), Colors.green, Icons.check_circle),
        _buildStatCard('En Limpieza', dashboardData.occupiedBathrooms.toString(), Colors.orange, Icons.people),
        _buildStatCard('En Mantenimiento', dashboardData.maintenanceBathrooms.toString(), Colors.purple, Icons.build),
        _buildStatCard('Incidencias Activas', dashboardData.activeIncidents.toString(), Colors.red, Icons.report_problem),
        _buildStatCard('Mantenimientos Abiertos', dashboardData.openMaintenances.toString(), Colors.deepOrange, Icons.warning),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  title, 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentFilter(AnalyticsProvider provider) {
    return Row(
      children: [
        const Text('Agrupar por: '),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: provider.incidentGroupBy,
          items: const [
            DropdownMenuItem(value: 'bathroom', child: Text('Baño')),
            DropdownMenuItem(value: 'block', child: Text('Bloque')),
            DropdownMenuItem(value: 'category', child: Text('Categoría')),
          ],
          onChanged: (value) {
            if (value != null) {
              provider.setIncidentGroupBy(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildMaintenanceFilters(AnalyticsProvider provider, BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DropdownButton<String>(
          value: _pendingMaintenanceStatus,
          items: const [
            DropdownMenuItem(value: 'all', child: Text('Todos (Estado)')),
            DropdownMenuItem(value: 'open', child: Text('Abiertos')),
            DropdownMenuItem(value: 'closed', child: Text('Cerrados')),
          ],
          onChanged: (v) {
            setState(() {
              _pendingMaintenanceStatus = v;
            });
          },
        ),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _bathroomIdController,
            decoration: const InputDecoration(labelText: 'ID Baño', isDense: true),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              _pendingMaintenanceBathroomId = int.tryParse(v);
            },
          ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.date_range, size: 18),
          label: Text(_pendingMaintenanceStartDate == null 
              ? 'F. Inicio' 
              : _pendingMaintenanceStartDate!.toIso8601String().split('T')[0]),
          onPressed: () async {
            final date = await showDatePicker(
              context: context, 
              initialDate: DateTime.now(), 
              firstDate: DateTime(2020), 
              lastDate: DateTime(2030)
            );
            if (date != null) {
              setState(() => _pendingMaintenanceStartDate = date);
            }
          },
        ),
        TextButton.icon(
          icon: const Icon(Icons.date_range, size: 18),
          label: Text(_pendingMaintenanceEndDate == null 
              ? 'F. Fin' 
              : _pendingMaintenanceEndDate!.toIso8601String().split('T')[0]),
          onPressed: () async {
            final date = await showDatePicker(
              context: context, 
              initialDate: DateTime.now(), 
              firstDate: DateTime(2020), 
              lastDate: DateTime(2030)
            );
            if (date != null) {
              setState(() => _pendingMaintenanceEndDate = date);
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.indigoAccent),
          tooltip: 'Buscar',
          onPressed: () {
            provider.setMaintenanceFilters(
              status: _pendingMaintenanceStatus,
              bathroomId: _pendingMaintenanceBathroomId,
              startDate: _pendingMaintenanceStartDate,
              endDate: _pendingMaintenanceEndDate,
              clearBathroomId: _pendingMaintenanceBathroomId == null,
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Limpiar filtros',
          onPressed: () {
            setState(() {
              _pendingMaintenanceStatus = 'all';
              _pendingMaintenanceBathroomId = null;
              _pendingMaintenanceStartDate = null;
              _pendingMaintenanceEndDate = null;
              _bathroomIdController.clear();
            });
            provider.clearMaintenanceFilters();
          },
        )
      ],
    );
  }

  Widget _buildIncidentBarChart(dynamic incidentData) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxIncidentCount(incidentData) + 2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < incidentData.items.length) {
                    final item = incidentData.items[index];
                    String label = '';
                    if (incidentData.groupBy == 'bathroom') {
                      label = item.bathroomId.toString();
                    } else if (incidentData.groupBy == 'block') {
                      label = item.blockName;
                    } else {
                     label = item.category ?? 'N/A';
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(label, style: const TextStyle(fontSize: 10)),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: incidentData.items.asMap().entries.map<BarChartGroupData>((entry) {
            int index = entry.key;
            var item = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.count.toDouble(),
                  color: Colors.redAccent,
                  width: 16,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  double _getMaxIncidentCount(dynamic incidentData) {
    double max = 0;
    for (var item in incidentData.items) {
      if (item.count > max) max = item.count.toDouble();
    }
    return max;
  }

  Widget _buildMaintenancePieChart(dynamic maintenanceData) {
    int open = maintenanceData.openCount;
    int closed = maintenanceData.closedCount;

    if (open == 0 && closed == 0) {
      return const Text('Sin historial de mantenimiento.');
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            PieChartSectionData(
              color: Colors.deepOrange,
              value: open.toDouble(),
              title: 'Abiertos',
              radius: 60,
              titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            PieChartSectionData(
              color: Colors.teal,
              value: closed.toDouble(),
              title: 'Cerrados',
              radius: 60,
              titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
