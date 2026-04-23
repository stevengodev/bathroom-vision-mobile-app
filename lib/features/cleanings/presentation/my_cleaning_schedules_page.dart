import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_response.dart';
import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeeklySchedulePage extends StatefulWidget {
  const WeeklySchedulePage({super.key});

  @override
  State<WeeklySchedulePage> createState() => _WeeklySchedulePageState();
}

class _WeeklySchedulePageState extends State<WeeklySchedulePage> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<CleaningScheduleProvider>(
        context,
        listen: false,
      ).loadMySchedules();
    });
  }

  Map<int, String> dayMap = {
    1: "LU",
    2: "MA",
    3: "MI",
    4: "JU",
    5: "VI",
    6: "SA",
    7: "DO",
  };

  String mapDay(DateTime date) => dayMap[date.weekday]!;

  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  List<DateTime> getWeekDays(DateTime date) {
    final start = getStartOfWeek(date);
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  List<CleaningScheduleResponse> getEventsForDay(
    DateTime day,
    List<CleaningScheduleResponse> schedules,
  ) {
    return schedules.where((s) {
      final start = DateTime.parse(s.startDate);
      final end = DateTime.parse(s.endDate);

      if (day.isBefore(start) || day.isAfter(end)) return false;

      // DIARIO
      if (s.frequency.name == "DIARIO") return true;

      // SEMANAL
      final daysString = s.daysOfWeek ?? "";
      final days = daysString.isEmpty ? [] : daysString.split(",");

      return days.contains(mapDay(day));
    }).toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CleaningScheduleProvider>(context);

    final weekDays = getWeekDays(selectedDate);
    final events = getEventsForDay(selectedDate, provider.schedules);

    return Scaffold(
      appBar: AppBar(title: const Text("Mi horario")),

      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  setState(() {
                    selectedDate = getStartOfWeek(
                      selectedDate.add(const Duration(days: 7)),
                    );
                  });
                } else if (details.primaryVelocity! > 0) {
                  setState(() {
                    selectedDate = getStartOfWeek(
                      selectedDate.subtract(const Duration(days: 7)),
                    );
                  });
                }
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
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
                              dayMap[day.weekday]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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

  Widget _eventCard(CleaningScheduleResponse e, int index) {
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
              Text(e.startTime, style: const TextStyle(color: Colors.white)),
              Text(e.endTime, style: const TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(width: 16),
          Text(
            "Baño ${e.bathroomId}",
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
