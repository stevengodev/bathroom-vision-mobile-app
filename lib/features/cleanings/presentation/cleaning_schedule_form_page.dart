import 'package:flutter/material.dart';

class CleaningScheduleFormPage extends StatefulWidget {
  const CleaningScheduleFormPage({super.key});

  @override
  State<CleaningScheduleFormPage> createState() =>
      _CleaningScheduleFormPageState();
}

class _CleaningScheduleFormPageState extends State<CleaningScheduleFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedUser;
  final List<String> users = [
    'Juan',
    'María',
    'Carlos',
    'Luisa',
  ]; // ejemplo de usuarios
  String? selectedBathroom;
  DateTime? startDate;
  DateTime? endDate;
  String? frequency;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<String> bathrooms = ['Baño 1', 'Baño 2', 'Baño 3'];
  final List<String> frequencies = ['DAILY', 'WEEKLY', 'MONTHLY'];
  final List<String> daysOfWeek = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
  final Set<String> selectedDays = {};

  Future<void> pickDate(BuildContext context, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        if (isStart) {
          startDate = date;
        } else {
          endDate = date;
        }
      });
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
                // Baño
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Selecciona baño",
                  ),
                  items: bathrooms
                      .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                      .toList(),
                  initialValue: selectedBathroom,
                  onChanged: (v) => setState(() => selectedBathroom = v),
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Usuario responsable",
                  ),
                  items: users
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  initialValue: selectedUser,
                  onChanged: (v) => setState(() => selectedUser = v),
                ),
                const SizedBox(height: 16),

                // Fecha inicio
                // En el build(), para la fecha de inicio
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Fecha inicio",
                    suffixIcon: const Icon(Icons.calendar_today),
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

                // Para la fecha de fin
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Fecha fin",
                    suffixIcon: const Icon(Icons.calendar_today),
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
                  onChanged: (v) => setState(() => frequency = v),
                ),
                const SizedBox(height: 16),

                // Días de la semana
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Aquí se enviaría al backend
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Horario de limpieza creado"),
                          ),
                        );
                      }
                    },
                    child: const Text("Guardar horario"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
