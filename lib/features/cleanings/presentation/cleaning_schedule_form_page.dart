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
  final List<String> daysOfWeek = ['LU', 'MA', 'MI', 'JU', 'VI', 'SA', 'DO'];
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

      selectedBathroomId = s.bathroom.id;
      selectedUserId = s.userId;

      if (s.daysOfWeek != null && s.daysOfWeek!.isNotEmpty) {
        selectedDays.clear();
        selectedDays.addAll(s.daysOfWeek!.split(","));
      }
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

  final Color primaryGreen = const Color(0xFF8FD99F);

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryGreen),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryGreen, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bathroomProvider = Provider.of<BathroomProvider>(context);

    final users = userProvider.users ?? [];
    final bathrooms = bathroomProvider.bathrooms;

    bool isWeekly = frequency == 'SEMANAL';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          widget.schedule == null ? "Crear horario" : "Editar horario",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Detalles del Horario",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Tarjeta Principal
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: selectedBathroomId,
                        decoration: _inputDecoration("Selecciona baño", Icons.bathroom_outlined),
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        dropdownColor: Colors.white,
                        items: bathrooms.map((b) {
                          return DropdownMenuItem(
                            value: b.id,
                            child: Text(
                              "${b.nameBlock} - Piso ${b.floor} - ${b.gender.name}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => selectedBathroomId = v),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        initialValue: selectedUserId,
                        decoration: _inputDecoration("Usuario responsable", Icons.person_outline),
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        dropdownColor: Colors.white,
                        items: users.map((u) {
                          return DropdownMenuItem(
                            value: u.id, 
                            child: Text(u.name, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => selectedUserId = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  "Fechas y Frecuencia",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Tarjeta de Fechas y Frecuencia
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        readOnly: true,
                        decoration: _inputDecoration("Fecha inicio", Icons.calendar_today_outlined),
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
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: primaryGreen,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black87,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => startDate = picked);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        decoration: _inputDecoration("Fecha fin", Icons.event_outlined),
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
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: primaryGreen,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.black87,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() => endDate = picked);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: frequencies.contains(frequency) ? frequency : null,
                        decoration: _inputDecoration("Frecuencia", Icons.repeat_rounded),
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        dropdownColor: Colors.white,
                        items: frequencies
                            .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            frequency = v;
                          });
                        },
                      ),
                      
                      if (isWeekly) ...[
                        const SizedBox(height: 20),
                        const Text(
                          "Días de la semana",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: daysOfWeek.map((day) {
                            final isSelected = selectedDays.contains(day);
                            return FilterChip(
                              label: Text(day),
                              selected: isSelected,
                              showCheckmark: false,
                              selectedColor: primaryGreen,
                              backgroundColor: Colors.grey.shade100,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: isSelected ? primaryGreen : Colors.grey.shade300,
                                ),
                              ),
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
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  "Horario Diario",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Tarjeta de Horario
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => pickTime(context, true),
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200, width: 1.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time, color: primaryGreen),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Hora inicio", style: TextStyle(fontSize: 12, color: Colors.black54)),
                                      Text(
                                        startTime == null ? "--:--" : startTime!.format(context),
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => pickTime(context, false),
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200, width: 1.5),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.access_time_filled, color: primaryGreen),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Hora fin", style: TextStyle(fontSize: 12, color: Colors.black54)),
                                      Text(
                                        endTime == null ? "--:--" : endTime!.format(context),
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    
                    // Simple validation before submit
                    if (selectedBathroomId == null || selectedUserId == null || startDate == null || endDate == null || frequency == null || startTime == null || endTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Por favor, completa todos los campos requeridos"), 
                          backgroundColor: Colors.redAccent
                        ),
                      );
                      return;
                    }

                    final provider = Provider.of<CleaningScheduleProvider>(
                      context,
                      listen: false,
                    );

                    final request = CleaningScheduleRequest(
                      bathroomId: selectedBathroomId!,
                      userId: selectedUserId!,
                      startDate: formatDate(startDate!),
                      endDate: formatDate(endDate!),
                      frequency: CleaningFrequency.values.byName(frequency!),
                      daysOfWeek: frequency == 'SEMANAL'
                          ? formatDays()
                          : 'LU,MA,MI,JU,VI,SA,DO',
                      startTime: formatTime(startTime!),
                      endTime: formatTime(endTime!),
                    );

                    if (widget.schedule == null) {
                      await provider.create(request);
                    } else {
                      await provider.update(widget.schedule!.id, request);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.schedule == null
                              ? "Creado correctamente"
                              : "Actualizado correctamente",
                        ),
                        backgroundColor: primaryGreen,
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: Text(
                    widget.schedule == null ? "Crear Horario" : "Actualizar Horario",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
