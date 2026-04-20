import 'package:bathroom_vision/features/auth/presentation/user_provider.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_provider.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_request.dart';
import 'package:bathroom_vision/features/cleanings/presentation/cleaning_schedule_provider.dart';
import 'package:bathroom_vision/features/cleanings/models/cleaning_schedule_response.dart';
import 'package:bathroom_vision/shared/enums/cleaning_frecuency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/shared/enums/role.dart';

class CleaningScheduleFormPage extends StatefulWidget {
  final CleaningScheduleResponse? schedule;

  const CleaningScheduleFormPage({super.key, this.schedule});

  @override
  State<CleaningScheduleFormPage> createState() =>
      _CleaningScheduleFormPageState();
}

class _CleaningScheduleFormPageState extends State<CleaningScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();

  int? selectedUserId;
  int? selectedBathroomId;

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
      final bathroomProvider =
          Provider.of<BathroomProvider>(context, listen: false);

      userProvider.loadUsersByRole(Role.CLEANER);
      bathroomProvider.loadAllBathrooms();
    });

    if (widget.schedule != null) {
      final s = widget.schedule!;

      startDate = DateTime.parse(s.startDate);
      endDate = DateTime.parse(s.endDate);
      frequency = s.frequency.name;

      startTime = TimeOfDay(
        hour: int.parse(s.startTime.split(":")[0]),
        minute: int.parse(s.startTime.split(":")[1]),
      );

      endTime = TimeOfDay(
        hour: int.parse(s.endTime.split(":")[0]),
        minute: int.parse(s.endTime.split(":")[1]),
      );

      selectedBathroomId = s.bathroomId;
      selectedUserId = null;
    }
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
      appBar: AppBar(
        title: Text(widget.schedule == null
            ? "Crear horario"
            : "Editar horario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 BAÑO
                DropdownButtonFormField<int>(
                  value: selectedBathroomId,
                  decoration:
                      const InputDecoration(labelText: "Selecciona baño"),
                  items: bathrooms.map((b) {
                    return DropdownMenuItem(
                      value: b.id,
                      child: Text(
                          "${b.nameBlock} - Piso ${b.floor} - ${b.gender.name}"),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => selectedBathroomId = v),
                ),

                const SizedBox(height: 16),

                /// 🔹 USUARIO
                DropdownButtonFormField<int>(
                  value: selectedUserId,
                  decoration:
                      const InputDecoration(labelText: "Usuario responsable"),
                  items: users.map((u) {
                    return DropdownMenuItem(
                      value: u.id,
                      child: Text(u.name),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => selectedUserId = v),
                ),

                const SizedBox(height: 16),

                /// 🔹 FECHA INICIO
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
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => startDate = picked);
                    }
                  },
                ),

                const SizedBox(height: 16),

                /// 🔹 FECHA FIN
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
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => endDate = picked);
                    }
                  },
                ),

                const SizedBox(height: 16),

                /// 🔹 FRECUENCIA
                DropdownButtonFormField<String>(
                  value: frequencies.contains(frequency)
                      ? frequency
                      : null,
                  decoration:
                      const InputDecoration(labelText: "Frecuencia"),
                  items: frequencies
                      .map((f) =>
                          DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
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

                /// 🔹 DÍAS
                if (isWeekly) ...[
                  const Text("Días de la semana"),
                  Wrap(
                    spacing: 8,
                    children: daysOfWeek.map((day) {
                      final isSelected = selectedDays.contains(day);
                      return ChoiceChip(
                        label: Text(day),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selected
                                ? selectedDays.add(day)
                                : selectedDays.remove(day);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                /// 🔹 HORAS
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(startTime == null
                            ? "Hora inicio"
                            : startTime!.format(context)),
                        onTap: () => pickTime(context, true),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text(endTime == null
                            ? "Hora fin"
                            : endTime!.format(context)),
                        onTap: () => pickTime(context, false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// 🔥 BOTÓN
                ElevatedButton(
                  onPressed: () async {
                    final provider =
                        Provider.of<CleaningScheduleProvider>(
                      context,
                      listen: false,
                    );

                    final request = CleaningScheduleRequest(
                      bathroomId: selectedBathroomId!,
                      userId: selectedUserId!,
                      startDate: formatDate(startDate!),
                      endDate: formatDate(endDate!),
                      frequency: CleaningFrequency.values
                          .byName(frequency!),
                      daysOfWeek:
                          frequency == 'SEMANAL' ? formatDays() : null,
                      startTime: formatTime(startTime!),
                      endTime: formatTime(endTime!),
                    );

                    if (widget.schedule == null) {
                      await provider.create(request);
                    } else {
                      await provider.update(
                          widget.schedule!.id, request);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(widget.schedule == null
                            ? "Creado correctamente"
                            : "Actualizado correctamente"),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: Text(widget.schedule == null
                      ? "Crear"
                      : "Actualizar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}