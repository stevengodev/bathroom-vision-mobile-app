import 'package:bathroom_vision/features/auth/presentation/user_provider.dart';
import 'package:bathroom_vision/features/incidents/models/incident_response.dart';
import 'package:bathroom_vision/features/incidents/presentation/grouped_incident_card.dart';
import 'package:bathroom_vision/shared/enums/incident_message_category.dart';
import 'package:bathroom_vision/shared/enums/role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bathroom_vision/features/incidents/presentation/incident_provider.dart';
import 'package:bathroom_vision/shared/enums/incident_status.dart';

class PendingIncidentsPage extends StatefulWidget {
  const PendingIncidentsPage({super.key});

  @override
  State<PendingIncidentsPage> createState() => _PendingIncidentsPageState();
}

class _PendingIncidentsPageState extends State<PendingIncidentsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = context.read<UserProvider>();
      final incidentProvider = context.read<IncidentProvider>();

      await userProvider.loadUserProfile();

      final role = userProvider.user!.role;

      IncidentMessageCategory? category;

      if (role == Role.MAINTAINER.name) {
        category = IncidentMessageCategory.MANTENIMIENTO;
      } else if (role == Role.CLEANER.name) {
        category = IncidentMessageCategory.LIMPIEZA;
      } else {
        category = null;
      }

      await incidentProvider.loadAllIncidents(
        IncidentStatus.PENDING,
        category: category,
      );
    });

  }

  Color getIncidentColor(String status) {
    switch (status) {
      case "PENDING":
        return Colors.orange;
      case "RESOLVED":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IncidentProvider>();

    final pendingIncidents = provider.incidents;

    /// AGRUPAR INCIDENTES
    // final Map<String, List<dynamic>> grouped = {};
    final Map<String, List<IncidentResponse>> grouped = {};

    for (var incident in pendingIncidents) {
      final key = "${incident.bathroom.id}-${incident.incidentMessage.id}";

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }

      grouped[key]!.add(incident);
    }

    final groupedList = grouped.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Incidencias pendientes")),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : groupedList.isEmpty
          ? const Center(child: Text("No hay incidencias pendientes"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedList.length,
              itemBuilder: (context, index) {
                final group = groupedList[index].value;
                final first = group.first;

                return GroupedIncidentCard(
                  incidents: group,
                  statusColor: getIncidentColor(first.status),
                  onResolve: () async {
                    await context.read<IncidentProvider>().resolveIncident(
                      first.incidentMessage.id!,
                      first.bathroom.id,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Incidencias resueltas")),
                    );
                  },
                );
              },
            ),
    );
  }
}

