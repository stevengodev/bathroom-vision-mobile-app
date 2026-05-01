import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_form_page.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_provider.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_status_page.dart';

class MaintenanceDetailPage extends StatelessWidget {
  final MaintenanceResponse maintenance;

  const MaintenanceDetailPage({super.key, required this.maintenance});

  Color _statusColor(String status) {
    switch (status) {
      case "CERRADO":
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case "CERRADO":
        return Icons.check_circle;
      default:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(maintenance.status);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Detalle ticket",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// CARD PRINCIPAL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(Icons.build, color: statusColor, size: 28),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          "Ticket #${maintenance.id}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Descripción",
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    maintenance.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Divider(),

                  const SizedBox(height: 10),

                  _infoRow(
                    Icons.person,
                    "Técnico",
                    maintenance.technicianFullName,
                  ),

                  const SizedBox(height: 14),

                  _infoRow(
                    Icons.location_on,
                    "Baño",
                    "${maintenance.bathroom.nameBlock} - " +
                        "${maintenance.bathroom.floor}",
                  ),

                  const SizedBox(height: 14),

                  _infoRow(
                    Icons.wc,
                    "Genero",
                    maintenance.bathroom.gender.name,
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Icon(_statusIcon(maintenance.status), color: statusColor),
                      const SizedBox(width: 10),
                      const Text(
                        "Estado",
                        style: TextStyle(color: Colors.black54),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          maintenance.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            /// BOTONES
            _button(
              text: "ACTUALIZAR ESTADO",
              color: Colors.orange,
              icon: Icons.sync_alt,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MaintenanceStatusPage(maintenance: maintenance),
                  ),
                );

                if (result != null) {
                  Navigator.pop(context, true);
                }
              },
            ),

            const SizedBox(height: 12),

            _button(
              text: "EDITAR",
              color: Colors.blue,
              icon: Icons.edit,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        MaintenanceFormPage(maintenance: maintenance),
                  ),
                );

                if (result != null) {
                  Navigator.pop(context, true);
                }
              },
            ),

            const SizedBox(height: 12),

            _button(
              text: "ELIMINAR",
              color: Colors.red,
              icon: Icons.delete,
              onPressed: () async {
                await context.read<MaintenanceProvider>().deleteMaintenance(
                  maintenance.id,
                );

                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black54),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: Colors.black54)),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _button({
    required String text,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
