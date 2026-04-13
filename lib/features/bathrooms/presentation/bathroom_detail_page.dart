import 'package:bathroom_vision/features/auth/presentation/user_provider.dart';
import 'package:bathroom_vision/features/bathrooms/models/bathroom_request.dart';
import 'package:bathroom_vision/features/bathrooms/models/bathroom_response.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_card.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_form_page.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_provider.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_status_page.dart';
import 'package:bathroom_vision/features/incidents/models/incident_request.dart';
import 'package:bathroom_vision/features/incidents/presentation/incident_provider.dart';
import 'package:bathroom_vision/shared/utils/status_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BathroomDetailPage extends StatefulWidget {
  final BathroomResponse bathroom;

  const BathroomDetailPage({super.key, required this.bathroom});

  @override
  State<BathroomDetailPage> createState() => _BathroomDetailPageState();
}

class _BathroomDetailPageState extends State<BathroomDetailPage> {
  bool showIncidents = false;

  List<int> selectedMessages = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncidentProvider>().loadMessages();
      context.read<IncidentProvider>().loadIncidentsByBathroom(widget.bathroom.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bathroom = widget.bathroom;

    return Scaffold(
      appBar: AppBar(title: const Text("Detalles del baño")),
      backgroundColor: Colors.grey[100],
      body: Consumer<IncidentProvider>(
        builder: (context, provider, _) {
          /// AGRUPAR INCIDENTES
          final Map<int, List<dynamic>> grouped = {};

          for (var incident in provider.incidents) {
            final key = incident.incidentMessage.id!;

            if (!grouped.containsKey(key)) {
              grouped[key] = [];
            }

            grouped[key]!.add(incident);
          }

          final groupedList = grouped.entries.toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjeta principal
                BathroomCard(
                  bathroom: bathroom,
                  statusColor: getStatusColor(bathroom.status),
                  onTap: () {},
                ),

                const SizedBox(height: 20),

                // INCIDENTES
                GestureDetector(
                  onTap: () => setState(() => showIncidents = !showIncidents),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Incidentes reportados",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        showIncidents
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                if (showIncidents)
                  groupedList.isEmpty
                      ? const Text("No hay incidentes")
                      : Column(
                          children: groupedList.map((entry) {
                            final incidents = entry.value;
                            final first = incidents.first;

                            return _incidentCard(
                              first.incidentMessage.description,
                              "${incidents.length} reportes",
                            );
                          }).toList(),
                        ),

                const SizedBox(height: 20),

                // REPORTAR
                const Text(
                  "Reportar problema",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                provider.messages.isEmpty
                    ? const Text("No hay opciones disponibles")
                    : Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: provider.messages.map((msg) {
                          return _duolingoButton(
                            text: msg.description,
                            isSelected: selectedMessages.contains(msg.id),
                            onTap: () {
                              setState(() {
                                if (selectedMessages.contains(msg.id)) {
                                  selectedMessages.remove(msg.id);
                                } else {
                                  selectedMessages.add(msg.id!);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                const SizedBox(height: 30),

                // ACCIONES
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final request = BathroomRequest(
                            gender: bathroom.gender,
                            blockId: bathroom.blockId,
                            status: bathroom.status,
                            floor: bathroom.floor,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BathroomFormPage(
                                bathroom: request,
                                id: bathroom.id,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Editar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[400],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Eliminar baño"),
                              content: const Text(
                                "¿Estás seguro de que quieres eliminar este baño?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Eliminar",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await context
                                  .read<BathroomProvider>()
                                  .deleteBathroom(bathroom.id);

                              if (mounted) {
                                Navigator.pop(context, true);
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error al eliminar: $e"),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Eliminar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BathroomStatusPage(bathroom: bathroom),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "ACTUALIZAR ESTADO",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // BOTÓN FINAL
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedMessages.isEmpty
                        ? null
                        : () async {
                            final userProvider = context.read<UserProvider>();
                            await userProvider.loadUserProfile();

                            String email = userProvider.user!.email;

                            try {
                              final request = IncidentRequest(
                                email: email,
                                incidentMessageIds: selectedMessages,
                                bathroomId: bathroom.id,
                              );

                              await context
                                  .read<IncidentProvider>()
                                  .createIncident(request);

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Incidencia reportada"),
                                  ),
                                );

                                setState(() {
                                  selectedMessages.clear();
                                });

                                context
                                    .read<IncidentProvider>()
                                    .loadIncidentsByBathroom(bathroom.id);
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "REPORTAR INCIDENCIA",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _incidentCard(String title, String count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Chip(
            label: Text(count),
            backgroundColor: Colors.orange.shade200,
          ),
        ],
      ),
    );
  }

  /// BOTÓN tipo Duolingo
  Widget _duolingoButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: (MediaQuery.of(context).size.width - 48) / 2,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade400,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}