import 'package:flutter/material.dart';
import 'package:bathroom_vision/features/incidents/models/incident_response.dart';

class IncidentCard extends StatelessWidget {
  final IncidentResponse incident;
  final Color statusColor;
  final VoidCallback onTap;
  final VoidCallback? onResolve;

  const IncidentCard({
    super.key,
    required this.incident,
    required this.statusColor,
    required this.onTap,
    this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFFE8D4D4),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
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
                        incident.incidentMessage.description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          incident.status,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // UBICACIÓN
                Text(
                  '${incident.bathroom.blockName} - Piso ${incident.bathroom.floor}',
                  style: const TextStyle(fontSize: 13),
                ),

                const SizedBox(height: 6),

                // REPORTER
                Text(
                  'Reportado por: ${incident.reporter.name}',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),

                const SizedBox(height: 6),

                // FECHA
                Text(
                  'Fecha: ${incident.reportedAt.toLocal()}',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),

                // BOTÓN
                if (onResolve != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onResolve,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("RESOLVER"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}