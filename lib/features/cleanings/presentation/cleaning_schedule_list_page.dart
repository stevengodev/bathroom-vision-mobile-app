import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_provider.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_response.dart';
import 'cleaning_schedule_form_page.dart';

import 'package:intl/intl.dart';

String formatHour(String time) {
  final parsed = DateFormat("HH:mm:ss").parse(time);
  return DateFormat("hh:mm a").format(parsed);
}

class CleaningScheduleListPage extends StatefulWidget {
  const CleaningScheduleListPage({super.key});

  @override
  State<CleaningScheduleListPage> createState() => _CleaningScheduleListPageState();
}

class _CleaningScheduleListPageState extends State<CleaningScheduleListPage> {
  String? selectedBlock;
  DateTime startDate = DateTime(2026, 1, 1);
  DateTime endDate = DateTime(2026, 6, 30);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CleaningScheduleProvider>().loadSchedules();
    });
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2024),
      lastDate: endDate,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color.fromARGB(255, 27, 145, 11)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => startDate = picked);
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: startDate,
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color.fromARGB(255, 27, 145, 11)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => endDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CleaningScheduleProvider>();
    final schedules = provider.schedules;

    final blocks = schedules
      .map((s) => s.bathroom.nameBlock.trim())
      .toSet()
      .toList()
    ..sort();

    final filtered = schedules.where((s) {
      // FILTRO POR BLOQUE
      final matchBlock = selectedBlock == null ||
          s.bathroom.nameBlock.trim() == selectedBlock;

      // FECHAS
      final scheduleStart = DateTime.parse(s.startDate);
      final scheduleEnd = DateTime.parse(s.endDate);

      // FILTRO POR RANGO (intersección de fechas)
      final matchDate =
          scheduleStart.isBefore(endDate.add(const Duration(days: 1))) &&
          scheduleEnd.isAfter(startDate.subtract(const Duration(days: 1)));

      return matchBlock && matchDate;
    }).toList()
      ..sort((a, b) {
        final aTime = DateFormat("HH:mm:ss").parse(a.startTime);
        final bTime = DateFormat("HH:mm:ss").parse(b.startTime);
        return aTime.compareTo(bTime);
      });

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 12, 90, 6),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Colors.white, width: 4),
          ),
          onPressed: () => _navigateToForm(context, provider),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 320,
                  collapsedHeight: 100,
                  pinned: true,
                  stretch: true,
                  backgroundColor: const Color.fromARGB(255, 12, 90, 6),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Título
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Horarios",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: DropdownButtonHideUnderline(
                              child: DropdownButton<String?>(
                                value: selectedBlock,
                                dropdownColor: const Color.fromARGB(255, 255, 255, 255),
                                icon: const Icon(Icons.expand_more, color: Colors.white60),
                                isExpanded: true,
                                hint: const Text(
                                  "Todos los Bloques",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
                                ),
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child: Text("Todos los Bloques"),
                                  ),
                                  ...blocks.map(
                                    (b) => DropdownMenuItem<String?>(
                                      value: b,
                                      child: Text(" $b"),
                                    ),
                                  ),
                                ],
                                onChanged: (v) => setState(() => selectedBlock = v),
                              ),
                            ),
                            ),
                            const SizedBox(height: 12),

                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "FILTRO DE RANGO",
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 247, 247, 247),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const Icon(Icons.date_range, size: 16, color: Color.fromARGB(237, 255, 255, 255)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _dateTapField(
                                          label: "Desde",
                                          date: startDate,
                                          onTap: _selectStartDate,
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Icon(Icons.arrow_forward, color: Color.fromARGB(237, 255, 255, 255), size: 16),
                                      ),
                                      Expanded(
                                        child: _dateTapField(
                                          label: "Hasta",
                                          date: endDate,
                                          onTap: _selectEndDate,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _listHeader(filtered.length),
                      const SizedBox(height: 20),
                      if (filtered.isEmpty)
                        _emptyState()
                      else
                        ...filtered.map((s) => _scheduleCard(context, s, provider)),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _dateTapField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_calendar_outlined, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _listHeader(int count) {
  return Column(
    children: [
      Center(
        child: Text(
          "Horarios Vigentes",
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color.fromARGB(161, 166, 210, 158),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color.fromARGB(255, 86, 154, 90)),
        ),
        child: Text(
          "$count ENCONTRADOS",
          style: const TextStyle(
            color: Color.fromARGB(255, 12, 90, 6),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    ],
  );
}

  Widget _scheduleCard(BuildContext context, CleaningScheduleResponse s, CleaningScheduleProvider provider) {
    final isDiario = s.frequency.name.toUpperCase() == 'DIARIO';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
        border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 4)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDiario ? const Color.fromARGB(255, 12, 90, 6) : Colors.deepOrangeAccent[400],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Text(
                s.frequency.name.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(color: Colors.indigo[50], borderRadius: BorderRadius.circular(20)),
                      child: Icon(Icons.access_time_filled, color: const Color.fromARGB(255, 12, 90, 6), size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${formatHour(s.startTime)} - ${formatHour(s.endTime)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 14, color: Colors.black26),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  s.userName,
                                  style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _actionButtons(context, s, provider),
                  ],
                ),
                
                   
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context, CleaningScheduleResponse s, CleaningScheduleProvider provider) {
  return Row(
    children: [
      IconButton(
        onPressed: () => _showDetailsDialog(context, s),
        icon: const Icon(Icons.visibility_outlined, color: Colors.blueGrey, size: 22),
        visualDensity: VisualDensity.compact,
      ),
      IconButton(
        onPressed: () => _navigateToForm(context, provider, schedule: s),
        icon: const Icon(Icons.edit_outlined, color: Colors.black26, size: 22),
        visualDensity: VisualDensity.compact,
      ),
      IconButton(
        onPressed: () => _confirmDelete(context, s, provider),
        icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
        visualDensity: VisualDensity.compact,
      ),
    ],
  );
  
}

  Widget _dateInfo(String label, String date) {
    final d = DateTime.parse(date);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black26, fontSize: 8, fontWeight: FontWeight.w900)),
        Text(
          "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}",
          style: const TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _genderBadge(String gender) {
    Color color = Colors.purple;
    String text = "UNISEX";
    if (gender == "MALE") { color = Colors.blue; text = "HOMBRES"; }
    if (gender == "FEMALE") { color = Colors.pink; text = "MUJERES"; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900)),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black.withOpacity(0.05), width: 2),
      ),
      child: const Column(
        children: [
          Icon(Icons.filter_list_off, size: 48, color: Colors.black12),
          SizedBox(height: 16),
          Text("No hay turnos en este rango", style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, CleaningScheduleResponse s) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 10,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Detalles del turno",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // UBICACIÓN
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${s.bathroom.nameBlock} • Piso ${s.bathroom.floor}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // FECHAS
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.event, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            "Fecha inicio",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black45,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.startDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(Icons.event_available, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            "Fecha fin",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black45,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.endDate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // DÍAS
                  if (s.daysOfWeek != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_view_week, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          s.daysOfWeek!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // ❌ BOTÓN X (cerrar)
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _detailItem(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, size: 18, color: const Color.fromARGB(255, 12, 90, 6)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black38,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
void _confirmDelete(
  BuildContext context,
  CleaningScheduleResponse s,
  CleaningScheduleProvider provider,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 40, color: Colors.redAccent),
              const SizedBox(height: 10),

              const Text(
                "¿Eliminar turno?",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Se eliminará el turno de ${formatHour(s.startTime)} - ${formatHour(s.endTime)} asignado a ${s.userName}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  // CANCELAR
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancelar"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // ELIMINAR
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // cerrar modal

                        await provider.delete(s.id);
                        await provider.loadSchedules();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Turno eliminado correctamente"),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Eliminar"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
  void _navigateToForm(BuildContext context, CleaningScheduleProvider provider, {CleaningScheduleResponse? schedule}) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => CleaningScheduleFormPage(schedule: schedule)));
    provider.loadSchedules();
  }
}