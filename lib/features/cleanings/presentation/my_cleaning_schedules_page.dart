import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklySchedulePage extends StatefulWidget {
  const WeeklySchedulePage({super.key});

  @override
  State<WeeklySchedulePage> createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  DateTime selectedDate = DateTime.now();

  ////////////////////////////////////////////////////////////
  /// MOCK BACKEND
  ////////////////////////////////////////////////////////////
  final List<Map<String, dynamic>> schedules = [
    {
      "bathroomId": 1,
      "startDate": "2026-01-01",
      "endDate": "2026-06-30",
      "frequency": "WEEKLY",
      "daysOfWeek": "MO,WE,FR",
      "startTime": "08:00",
      "endTime": "09:00"
    },
    {
      "bathroomId": 2,
      "startDate": "2026-01-01",
      "endDate": "2026-06-30",
      "frequency": "DAILY",
      "daysOfWeek": "",
      "startTime": "10:00",
      "endTime": "11:00"
    },
  ];

  ////////////////////////////////////////////////////////////
  /// 🔹 INICIO DE SEMANA (LUNES)
  ////////////////////////////////////////////////////////////
  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  ////////////////////////////////////////////////////////////
  /// 🔹 LISTA DE DÍAS
  ////////////////////////////////////////////////////////////
  List<DateTime> getWeekDays(DateTime date) {
    final start = getStartOfWeek(date);
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  ////////////////////////////////////////////////////////////
  /// 🔹 MAPEAR DÍA
  ////////////////////////////////////////////////////////////
  String mapDay(DateTime date) {
    const map = {
      1: "MO",
      2: "TU",
      3: "WE",
      4: "TH",
      5: "FR",
      6: "SA",
      7: "SU",
    };
    return map[date.weekday]!;
  }

  ////////////////////////////////////////////////////////////
  /// 🔹 FILTRAR EVENTOS
  ////////////////////////////////////////////////////////////
  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    return schedules.where((s) {
      final start = DateTime.parse(s["startDate"] as String);
      final end = DateTime.parse(s["endDate"] as String);

      if (day.isBefore(start) || day.isAfter(end)) return false;

      if (s["frequency"] == "DAILY") return true;

      final daysString = s["daysOfWeek"] as String? ?? "";
      final days = daysString.isEmpty ? [] : daysString.split(",");

      return days.contains(mapDay(day));
    }).toList()
      ..sort((a, b) =>
          (a["startTime"] as String)
              .compareTo(b["startTime"] as String));
  }

  ////////////////////////////////////////////////////////////
  /// UI
  ////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final weekDays = getWeekDays(selectedDate);
    final events = getEventsForDay(selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text("Mi horario")),

      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // 👉 siguiente semana
            setState(() {
              selectedDate = getStartOfWeek(
                selectedDate.add(const Duration(days: 7)),
              );
            });
          } else if (details.primaryVelocity! > 0) {
            // 👉 semana anterior
            setState(() {
              selectedDate = getStartOfWeek(
                selectedDate.subtract(const Duration(days: 7)),
              );
            });
          }
        },

        child: Column(
          children: [

            //////////////////////////////////////////////////////
            /// 🔥 HEADER SEMANA
            //////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        selectedDate = getStartOfWeek(
                          selectedDate.subtract(const Duration(days: 7)),
                        );
                      });
                    },
                  ),

                  Text(
                    "${DateFormat('MMM d').format(weekDays.first)} - "
                    "${DateFormat('d').format(weekDays.last)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        selectedDate = getStartOfWeek(
                          selectedDate.add(const Duration(days: 7)),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),

            //////////////////////////////////////////////////////
            /// 🔥 DÍAS DE LA SEMANA
            //////////////////////////////////////////////////////
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays.map((day) {
                final isSelected =
                    DateFormat('yyyy-MM-dd').format(day) ==
                    DateFormat('yyyy-MM-dd').format(selectedDate);

                return GestureDetector(
                  onTap: () => setState(() => selectedDate = day),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('E').format(day),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            //////////////////////////////////////////////////////
            /// 🔥 EVENTOS
            //////////////////////////////////////////////////////
            Expanded(
              child: events.isEmpty
                  ? const Center(child: Text("No hay limpiezas"))
                  : ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final e = events[index];
                        return _eventCard(e, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////
  /// 🎨 CARD
  ////////////////////////////////////////////////////////////
  Widget _eventCard(Map<String, dynamic> e, int index) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];

    final color = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e["startTime"],
                  style: const TextStyle(color: Colors.white)),
              Text(e["endTime"],
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            "Baño ${e["bathroomId"]}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}