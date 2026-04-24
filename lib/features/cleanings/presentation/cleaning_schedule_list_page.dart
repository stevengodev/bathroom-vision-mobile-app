import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_provider.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_response.dart';
import 'cleaning_schedule_form_page.dart';

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
          colorScheme: const ColorScheme.light(primary: Colors.indigo),
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
          colorScheme: const ColorScheme.light(primary: Colors.indigo),
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

    final filtered = schedules.where((s) {
      final matchBlock = selectedBlock == null || s.bathroom.nameBlock == selectedBlock;
      final sStart = DateTime.parse(s.startDate);
      final sEnd = DateTime.parse(s.endDate);
      final matchDate = sStart.isBefore(endDate.add(const Duration(days: 1))) &&
          sEnd.isAfter(startDate.subtract(const Duration(days: 1)));
      return matchBlock && matchDate;
    }).toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.indigo[600],
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
                  backgroundColor: Colors.indigo[700],
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
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.calendar_month, color: Colors.white),
                                ),
                                const SizedBox(width: 12),
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
                                  dropdownColor: Colors.grey[800],
                                  icon: const Icon(Icons.expand_more, color: Colors.white60),
                                  isExpanded: true,
                                  hint: const Text(
                                    "Todos los Bloques",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  items: [null, "A", "B", "C", "D", "E"]
                                      .map((b) => DropdownMenuItem(
                                            value: b,
                                            child: Text(b == null ? "Todos los Bloques" : "Bloque $b"),
                                          ))
                                      .toList(),
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
                                          color: Colors.indigo[200],
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const Icon(Icons.date_range, size: 16, color: Colors.white24),
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
                                        child: Icon(Icons.arrow_forward, color: Colors.white24, size: 16),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Horarios Vigentes",
              style: TextStyle(color: Color(0xFF1E293B), fontSize: 22, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.indigo[50],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.indigo[100]!),
          ),
          child: Text(
            "$count ENCONTRADOS",
            style: TextStyle(color: Colors.indigo[600], fontSize: 10, fontWeight: FontWeight.w900),
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
                color: isDiario ? Colors.indigo[500] : Colors.deepOrangeAccent[400],
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
                      child: Icon(Icons.access_time_filled, color: Colors.indigo[600], size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${s.startTime} - ${s.endTime}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
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
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 18, color: Colors.indigoAccent),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("UBICACIÓN", style: TextStyle(color: Colors.black26, fontSize: 9, fontWeight: FontWeight.w900)),
                              Text(
                                "${s.bathroom.nameBlock} • PISO ${s.bathroom.floor}",
                                style: const TextStyle(color: Color(0xFF334155), fontSize: 12, fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ],
                      ),
                      _genderBadge(s.bathroom.gender.name),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _dateInfo("INICIO", s.startDate),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.arrow_forward, size: 14, color: Colors.black12),
                        ),
                        _dateInfo("FIN", s.endDate),
                      ],
                    ),
                    if (s.daysOfWeek != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          s.daysOfWeek!,
                          style: TextStyle(color: Colors.grey[700], fontSize: 10, fontWeight: FontWeight.w900),
                        ),
                      ),
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
          onPressed: () => _navigateToForm(context, provider, schedule: s),
          icon: const Icon(Icons.edit_outlined, color: Colors.black26, size: 22),
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          onPressed: () => provider.delete(s.id).then((_) => provider.loadSchedules()),
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

  void _navigateToForm(BuildContext context, CleaningScheduleProvider provider, {CleaningScheduleResponse? schedule}) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => CleaningScheduleFormPage(schedule: schedule)));
    provider.loadSchedules();
  }
}