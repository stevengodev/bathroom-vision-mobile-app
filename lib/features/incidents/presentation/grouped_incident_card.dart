import 'package:bathroom_vision/features/incidents/models/incident_response.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupedIncidentCard extends StatelessWidget {
  final List<IncidentResponse> incidents;
  final Color statusColor;
  final VoidCallback onResolve;

  const GroupedIncidentCard({
    super.key,
    required this.incidents,
    required this.statusColor,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    final first = incidents.first;

    final users = incidents.map((e) => e.reporter.email).toSet().toList();

    final dates = incidents.map((e) => e.reportedAt).toList();

    final formatter = DateFormat('dd/MM/yyyy HH:mm', 'es');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    first.incidentMessage.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text("${incidents.length} reportes"),
                  backgroundColor: Colors.orange.shade100,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "${first.bathroom.blockName} - Piso ${first.bathroom.floor} - ${first.bathroom.gender.name}",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            const Text(
              "Reportado por:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            ...users.take(3).map((u) => Text("• $u")),

            if (users.length > 3) Text("+${users.length - 3} más"),

            const SizedBox(height: 12),

            const Text(
              "Fechas:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            ...dates.take(3).map(
              (d) => Text(formatter.format(d)),
            ),

            if (dates.length > 3) Text("+${dates.length - 3} más"),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: onResolve,
                child: const Text(
                  "RESOLVER TODOS",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}