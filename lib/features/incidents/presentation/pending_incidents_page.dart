import 'package:bathroom_vision/features/incidents/presentation/incident_card.dart';
import 'package:bathroom_vision/shared/enums/incident_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bathroom_vision/features/incidents/presentation/incident_provider.dart';

class PendingIncidentsPage extends StatefulWidget {
  const PendingIncidentsPage({super.key});

  @override
  State<PendingIncidentsPage> createState() =>
      _PendingIncidentsPageState();
}

class _PendingIncidentsPageState extends State<PendingIncidentsPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncidentProvider>().loadAllIncidents(IncidentStatus.PENDING);
    });
  }

  // color por estado
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

    final pendingIncidents = provider.incidents
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Incidencias pendientes"),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : pendingIncidents.isEmpty
              ? const Center(child: Text("No hay incidencias pendientes"))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pendingIncidents.length,
                  itemBuilder: (context, index) {
                    final incident = pendingIncidents[index];

                    return IncidentCard(
                      incident: incident,
                      statusColor: getIncidentColor(incident.status),

                      onTap: () {},

                      // botón resolver
                      onResolve: () async {
                        await context
                            .read<IncidentProvider>()
                            .resolveIncident(
                              incident.incidentMessage.id!,
                              incident.bathroom.id,
                            );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Incidencia resuelta"),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}