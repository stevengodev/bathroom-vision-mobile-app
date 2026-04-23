import 'package:bathroom_vision/shared/enums/cleaning_frecuency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_provider.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_response.dart';

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
      context.read<CleaningScheduleProvider>().loadSchedules();
    });
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
    final provider = context.watch<CleaningScheduleProvider>();

    final List<CleaningScheduleResponse> schedules =
        provider.schedules;

    /// 🔎 FILTRO
    final List<CleaningScheduleResponse> filtered =
        schedules.where((s) {
      final blockName = s.bathroom.nameBlock;

      final matchBlock =
          selectedBlock == null || blockName == selectedBlock;

      final date = DateTime.parse(s.startDate);

      final matchDate = selectedDate == null ||
          (date.year == selectedDate!.year &&
              date.month == selectedDate!.month &&
              date.day == selectedDate!.day);

      return matchBlock && matchDate;
    }).toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CleaningScheduleFormPage(),
            ),
          );

          provider.loadSchedules();
        },
        child: const Icon(Icons.add),
      ),

      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                /// 🔝 HEADER
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
                          Expanded(
                            child: DropdownButtonFormField<String?>(
                              initialValue: selectedBlock,
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

                          IconButton(
                            icon: const Icon(Icons.calendar_month, size: 35),
                            onPressed: pickDate,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// 📋 LISTA
SliverPadding(
  padding: const EdgeInsets.all(12),
  sliver: SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        final s = filtered[index];
        final b = s.bathroom;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          child: Card(
            elevation: 3,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔝 HEADER (HORA + USUARIO)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// ⏰ HORA
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            "${s.startTime} - ${s.endTime}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      /// 👤 USUARIO
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              s.userName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// 🏢 UBICACIÓN
                  Text(
                    "Bloque ${b.nameBlock} • Piso ${b.floor}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// 🚻 GENERO
                  Text(
                    "Baño: ${_getGenderText(b.gender.name)}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 📅 FECHAS
                  Row(
                    children: [
                      const Icon(Icons.date_range, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${_formatDate(s.startDate)} → ${_formatDate(s.endDate)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// 🔁 FRECUENCIA + DÍAS
                  Row(
                    children: [
                      _buildBadge(
                        s.frequency.name,
                        Colors.blue,
                      ),
                      const SizedBox(width: 6),
                      if (s.daysOfWeek != null)
                        _buildBadge(
                          s.daysOfWeek!,
                          Colors.teal,
                        ),
                      const SizedBox(width: 6),
                      _buildBadge(
                        _getGenderText(b.gender.name),
                        _getGenderColor(b.gender.name),
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  /// ✏️ ACCIONES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                          context
                              .read<CleaningScheduleProvider>()
                              .loadSchedules();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red),
                        onPressed: () async {
                          await context
                              .read<CleaningScheduleProvider>()
                              .delete(s.id);
                          context
                              .read<CleaningScheduleProvider>()
                              .loadSchedules();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      childCount: filtered.length,
    ),
  ),
),


              ],
            ),
    );
  }

  /// 🔁 FRECUENCIA BONITA
  String _buildFrequencyText(CleaningScheduleResponse s) {
    switch (s.frequency) {
      case CleaningFrequency.DIARIO:
        return "Todos los días";
      case CleaningFrequency.SEMANAL:
        if (s.daysOfWeek == null) return "Semanal";
        return "Días: ${s.daysOfWeek!.split(",").join(", ")}";
      default:
        return "";
    }
  }

  /// 📅 FORMATO FECHA
  String _formatDate(String date) {
    final d = DateTime.parse(date);
    return "${d.day}/${d.month}/${d.year}";
  }

  /// 🚻 TEXTO GENERO
  String _getGenderText(String gender) {
    switch (gender) {
      case "MALE":
        return "Hombres";
      case "FEMALE":
        return "Mujeres";
      case "UNISEX":
        return "Unisex";
      default:
        return gender;
    }
  }

  /// 🎨 COLOR GENERO
  Color _getGenderColor(String gender) {
    switch (gender) {
      case "MALE":
        return Colors.blue;
      case "FEMALE":
        return Colors.pink;
      case "UNISEX":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

Widget _buildBadge(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 11,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}