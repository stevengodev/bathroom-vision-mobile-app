import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_provider.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_provider.dart';
import 'package:bathroom_vision/features/bathrooms/models/bathroom_response.dart';

import 'cleaning_schedule_form_page.dart';

class CleaningScheduleListPage extends StatefulWidget {
  const CleaningScheduleListPage({super.key});

  @override
  State<CleaningScheduleListPage> createState() =>
      _CleaningScheduleListPageState();
}

class _CleaningScheduleListPageState
    extends State<CleaningScheduleListPage> {
  String? selectedBlock;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<CleaningScheduleProvider>(context, listen: false)
          .loadSchedules();

      /// 🔥 IMPORTANTE: cargar baños
      Provider.of<BathroomProvider>(context, listen: false)
          .loadAllBathrooms();
    });
  }

  /// 🔥 OBTENER NOMBRE DE BLOQUE DESDE ID
  String getBlockName(int bathroomId, List<BathroomResponse> bathrooms) {
    try {
      final b = bathrooms.firstWhere((e) => e.id == bathroomId);
      return b.nameBlock;
    } catch (e) {
      return "N/A";
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CleaningScheduleProvider>(context);
    final bathroomProvider = Provider.of<BathroomProvider>(context);

    final schedules = provider.schedules;
    final bathrooms = bathroomProvider.bathrooms;

    /// 🔥 FILTRO
    final filtered = schedules.where((s) {
      final blockName = getBlockName(s.bathroomId, bathrooms);

      final matchBlock =
          selectedBlock == null || blockName == selectedBlock;

      final date = DateTime.parse(s.startDate);

      final matchDate = selectedDate == null ||
          (date.year == selectedDate!.year &&
              date.month == selectedDate!.month &&
              date.day == selectedDate!.day);

      return matchBlock && matchDate;
    }).toList();

    /// 🔥 AGRUPAR
    final map = <String, List<dynamic>>{};
    for (var item in filtered) {
      final block = getBlockName(item.bathroomId, bathrooms);

      map.putIfAbsent(block, () => []);
      map[block]!.add(item);
    }

    final data = map.entries.toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CleaningScheduleFormPage(),
            ),
          );

          /// 🔥 refrescar al volver
          provider.loadSchedules();
        },
        child: const Icon(Icons.add),
      ),

      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                /// 🔥 APPBAR
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  expandedHeight: 170,
                  title: const Text("Horarios de Limpieza"),

                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(90),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          /// 🔹 BLOQUE
                          Expanded(
                            child: DropdownButtonFormField<String?>(
                              value: selectedBlock,
                              decoration: const InputDecoration(
                                labelText: "Bloque",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text("Todos"),
                                ),
                                ...["A", "B", "C", "D", "E", "F", "G"]
                                    .map(
                                  (b) => DropdownMenuItem(
                                    value: b,
                                    child: Text("Bloque $b"),
                                  ),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => selectedBlock = v),
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// 🔹 FECHA
                          IconButton(
                            icon: const Icon(Icons.calendar_month, size: 35),
                            onPressed: pickDate,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// 🔥 LISTA
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = data[index];
                      final block = entry.key;
                      final schedules = entry.value;

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ExpansionTile(
                          title: Text("Bloque $block"),
                          children: schedules.map<Widget>((s) {
                            return ListTile(
                              title:
                                  Text("${s.startTime} - ${s.endTime}"),

                              /// ⚠️ NO TIENES userName EN TU MODELO
                              subtitle: Text("🧹 Baño ID: ${s.bathroomId}"),

                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// ✏️ EDITAR
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CleaningScheduleFormPage(
                                            schedule: s,
                                          ),
                                        ),
                                      );

                                      provider.loadSchedules();
                                    },
                                  ),

                                  /// 🗑 ELIMINAR
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      await provider.delete(s.id);

                                      provider.loadSchedules();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Horario eliminado"),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                    childCount: data.length,
                  ),
                ),
              ],
            ),
    );
  }
}