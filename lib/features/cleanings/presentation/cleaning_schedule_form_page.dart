import 'package:bathroom_vision/features/auth/presentation/user_provider.dart';
import 'package:bathroom_vision/features/bathrooms/models/bathroom_response.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_provider.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_request.dart';
import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_provider.dart';
import 'package:bathroom_vision/shared/enums/cleaning_frecuency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/auth/models/user_response.dart';
import 'package:bathroom_vision/shared/enums/role.dart';

class CleaningScheduleFormPage extends StatefulWidget {
  const CleaningScheduleFormPage({super.key});

  @override
  State<CleaningScheduleFormPage> createState() =>
      _CleaningScheduleFormPageState();
}

class _CleaningScheduleFormPageState extends State<CleaningScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();

  UserResponse? selectedUser;
  BathroomResponse? selectedBathroom;

  DateTime? startDate;
  DateTime? endDate;
  String? frequency;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<String> frequencies = ['DIARIO', 'SEMANAL'];
  final List<String> daysOfWeek = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
  final Set<String> selectedDays = {};

  String formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  String formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:"
        "${time.minute.toString().padLeft(2, '0')}:00";
  }

  String? formatDays() {
    if (selectedDays.isEmpty) return null;
    return selectedDays.join(',');
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final bathroomProvider = Provider.of<BathroomProvider>(
        context,
        listen: false,
      );

      userProvider.loadUsersByRole(Role.CLEANER);
      bathroomProvider.loadBathrooms();
    });
  }

  Future<void> pickTime(BuildContext context, bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        if (isStart) {
          startTime = time;
        } else {
          endTime = time;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bathroomProvider = Provider.of<BathroomProvider>(context);

    final users = userProvider.users ?? [];

    final bathrooms = bathroomProvider.bathrooms;

    bool isWeekly = frequency == 'SEMANAL';

    return Scaffold(
      appBar: AppBar(title: const Text("Crear horario de limpieza")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Baños dinámicos
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: "Selecciona baño",
                  ),
                  items: bathrooms.map<DropdownMenuItem>((b) {
                    return DropdownMenuItem(
                      value: b,
                      child: Text(
                        "${b.nameBlock} - Piso ${b.floor} - ${b.gender.name}",
                      ),
                    );
                  }).toList(),
                  initialValue: selectedBathroom,
                  onChanged: (v) => setState(() => selectedBathroom = v),
                ),
                const SizedBox(height: 16),

                // 🔹 Usuarios dinámicos (CLEANER)
                DropdownButtonFormField<UserResponse>(
                  decoration: const InputDecoration(
                    labelText: "Usuario responsable",
                  ),
                  items: users
                      .map(
                        (u) => DropdownMenuItem(value: u, child: Text(u.name)),
                      )
                      .toList(),
                  initialValue: selectedUser,
                  onChanged: (v) => setState(() => selectedUser = v),
                ),
                const SizedBox(height: 16),

                // Fecha inicio
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Fecha inicio",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: startDate != null
                        ? "${startDate!.toLocal()}".split(' ')[0]
                        : "",
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        startDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Fecha fin
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Fecha fin",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: endDate != null
                        ? "${endDate!.toLocal()}".split(' ')[0]
                        : "",
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() {
                        endDate = picked;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Frecuencia
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Frecuencia"),
                  items: frequencies
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  initialValue: frequency,
                  onChanged: (v) {
                    setState(() {
                      frequency = v;

                      if (frequency == 'DIARIO') {
                        selectedDays.clear();
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Días (solo WEEKLY)
                if (isWeekly) ...[
                  const Text("Días de la semana"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: daysOfWeek.map((day) {
                      final isSelected = selectedDays.contains(day);
                      return ChoiceChip(
                        label: Text(day),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedDays.add(day);
                            } else {
                              selectedDays.remove(day);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Horas
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          startTime == null
                              ? "Hora inicio"
                              : startTime!.format(context),
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: () => pickTime(context, true),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          endTime == null
                              ? "Hora fin"
                              : endTime!.format(context),
                        ),
                        trailing: const Icon(Icons.access_time),
                        onTap: () => pickTime(context, false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () async {
                    if (selectedUser == null ||
                        selectedBathroom == null ||
                        startDate == null ||
                        endDate == null ||
                        startTime == null ||
                        endTime == null ||
                        frequency == null ||
                        (frequency == 'SEMANAL' && selectedDays.isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Completa todos los campos"),
                        ),
                      );
                      return;
                    }

                    final provider = Provider.of<CleaningScheduleProvider>(
                      context,
                      listen: false,
                    );

                    final request = CleaningScheduleRequest(
                      bathroomId: selectedBathroom!.id,
                      userId: selectedUser!.id,
                      startDate: formatDate(startDate!),
                      endDate: formatDate(endDate!),
                      frequency: CleaningFrequency.values.byName(frequency!),
                      daysOfWeek: frequency == 'SEMANAL' ? formatDays() : null,
                      startTime: formatTime(startTime!),
                      endTime: formatTime(endTime!),
                    );

                    await provider.create(request);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Horario creado correctamente"),
                      ),
                    );

                    Navigator.pop(context); // opcional
                  },
                  child: const Text("Guardar horario"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
