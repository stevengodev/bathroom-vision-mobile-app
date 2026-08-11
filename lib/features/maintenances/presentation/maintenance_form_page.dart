
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_provider.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_request.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_provider.dart';

class MaintenanceFormPage extends StatefulWidget {
  final MaintenanceResponse? maintenance;

  const MaintenanceFormPage({
    super.key,
    this.maintenance,
  });

  @override
  State<MaintenanceFormPage> createState() =>
      _MaintenanceFormPageState();
}

class _MaintenanceFormPageState
    extends State<MaintenanceFormPage> {
  final _formKey = GlobalKey<FormState>();

  int? selectedBathroomId;

  final technicianController = TextEditingController();

  final descriptionController = TextEditingController();

  DateTime? scheduledDateTime;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      // Cargar baños
      await context
          .read<BathroomProvider>()
          .loadAllBathrooms();

      // Cargar mantenimientos existentes
      try {
        await context
            .read<MaintenanceProvider>()
            .loadMaintenances();
      } catch (e) {
        debugPrint(
          'Error cargando mantenimientos: $e',
        );
      }
    });

    // Si estamos editando
    if (widget.maintenance != null) {
      final m = widget.maintenance!;

      selectedBathroomId = m.bathroom.id;

      technicianController.text =
          m.technicianFullName;

      descriptionController.text =
          m.description;

      scheduledDateTime =
          DateTime.tryParse(m.scheduledAt);
    }
  }

  @override
  void dispose() {
    technicianController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ============================================================
  // SELECCIONAR FECHA Y HORA
  // ============================================================

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(
        now.year,
        now.month,
        now.day,
      ),
      lastDate: DateTime(2035),
      initialDate: scheduledDateTime != null &&
              scheduledDateTime!.isAfter(
                DateTime(
                  now.year,
                  now.month,
                  now.day,
                ),
              )
          ? scheduledDateTime!
          : now,
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: scheduledDateTime != null
          ? TimeOfDay.fromDateTime(
              scheduledDateTime!,
            )
          : TimeOfDay.now(),
    );

    if (time == null) return;

    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // ==========================================================
    // VERIFICAR QUE NO SEA UNA FECHA/HORA PASADA
    // ==========================================================

    if (selectedDateTime.isBefore(
      DateTime.now(),
    )) {
      if (!mounted) return;

      _showWarning(
        "No puedes programar un mantenimiento en una fecha u hora que ya pasó.",
      );

      return;
    }

    setState(() {
      scheduledDateTime = selectedDateTime;
    });
  }

  // ============================================================
  // MOSTRAR MENSAJE DE ADVERTENCIA
  // ============================================================

  void _showWarning(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // MOSTRAR MENSAJE DE ÉXITO
  // ============================================================

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // MOSTRAR ERROR
  // ============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // GUARDAR MANTENIMIENTO
  // ============================================================

  Future<void> _saveMaintenance() async {
    // Evitar doble clic
    if (_saving) {
      return;
    }

    // ==========================================================
    // VALIDAR FORMULARIO
    // ==========================================================

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ==========================================================
    // VALIDAR FECHA
    // ==========================================================

    if (scheduledDateTime == null) {
      _showWarning(
        "Selecciona fecha y hora para el mantenimiento.",
      );

      return;
    }

    // ==========================================================
    // VALIDAR FECHA/HORA PASADA
    // ==========================================================

    if (scheduledDateTime!.isBefore(
      DateTime.now(),
    )) {
      _showWarning(
        "No puedes programar un mantenimiento en una fecha u hora que ya pasó.",
      );

      return;
    }

    // ==========================================================
    // OBTENER PROVIDER
    // ==========================================================

    final provider =
        context.read<MaintenanceProvider>();

    // ==========================================================
    // VERIFICAR HORARIO OCUPADO
    // ==========================================================

    final horarioOcupado =
        provider.isScheduleOccupied(
      bathroomId: selectedBathroomId!,
      scheduledAt: scheduledDateTime!,
      excludeMaintenanceId:
          widget.maintenance?.id,
    );

    if (horarioOcupado) {
      _showWarning(
        "No se puede hacer mantenimiento en ese horario porque el baño ya está ocupado.",
      );

      return;
    }

    // ==========================================================
    // ACTIVAR ESTADO DE GUARDADO
    // ==========================================================

    setState(() {
      _saving = true;
    });

    // ==========================================================
    // CREAR REQUEST
    // ==========================================================

    final request = MaintenanceRequest(
      bathroomId: selectedBathroomId!,
      technicianFullName:
          technicianController.text.trim(),
      description:
          descriptionController.text.trim(),
      scheduledAt:
          scheduledDateTime!.toIso8601String(),
    );

    try {
      // ========================================================
      // ACTUALIZAR
      // ========================================================

      if (widget.maintenance != null) {
        await provider.updateMaintenance(
          widget.maintenance!.id,
          request,
        );
      }

      // ========================================================
      // CREAR
      // ========================================================

      else {
        await provider.createMaintenance(
          request,
        );
      }

      if (!mounted) return;

      // ========================================================
      // MENSAJE DE ÉXITO
      // ========================================================

      _showSuccess(
        widget.maintenance != null
            ? "Mantenimiento actualizado correctamente."
            : "Mantenimiento creado correctamente.",
      );

      // Dar un pequeño tiempo para que se vea
      // el mensaje antes de regresar.
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    }

    // ==========================================================
    // ERROR
    // ==========================================================

    catch (e) {
      if (!mounted) return;

      final error = e.toString().toLowerCase();

      // ========================================================
      // DETECTAR CONFLICTO DE HORARIO
      // ========================================================

      final horarioOcupado =
          error.contains("ocupado") ||
          error.contains("horario") ||
          error.contains("conflicto") ||
          error.contains("conflict") ||
          error.contains("ya existe") ||
          error.contains("existente") ||
          error.contains("409");

      if (horarioOcupado) {
        _showWarning(
          "No se puede hacer mantenimiento en ese horario porque el baño ya está ocupado.",
        );
      } else {
        _showError(
          "No se pudo guardar el mantenimiento.",
        );

        debugPrint(
          "Error guardando mantenimiento: $e",
        );
      }
    }

    // ==========================================================
    // FINALIZAR ESTADO DE GUARDADO
    // ==========================================================

    finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bathrooms =
        context.watch<BathroomProvider>().bathrooms;

    final isEdit =
        widget.maintenance != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          isEdit
              ? "Editar mantenimiento"
              : "Nuevo mantenimiento",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Container(
            padding: const EdgeInsets.all(18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              children: [
                // ==================================================
                // TÍTULO
                // ==================================================

                _title(
                  "Información del mantenimiento",
                ),

                const SizedBox(height: 20),

                // ==================================================
                // BAÑO
                // ==================================================

                DropdownButtonFormField<int>(
                  value: selectedBathroomId,

                  decoration:
                      _inputDecoration(
                    "Baño",
                    Icons.bathroom,
                  ),

                  items: bathrooms
                      .map(
                        (b) => DropdownMenuItem<int>(
                          value: b.id,
                          child: Text(
                            "${b.nameBlock} - Piso ${b.floor} - ${b.gender.toDisplayString()}",
                          ),
                        ),
                      )
                      .toList(),

                  onChanged: _saving
                      ? null
                      : (value) {
                          setState(() {
                            selectedBathroomId =
                                value;
                          });
                        },

                  validator: (value) {
                    if (value == null) {
                      return "Selecciona un baño";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // TÉCNICO
                // ==================================================

                TextFormField(
                  controller:
                      technicianController,

                  enabled: !_saving,

                  decoration:
                      _inputDecoration(
                    "Técnico asignado",
                    Icons.person,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Campo requerido";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // DESCRIPCIÓN
                // ==================================================

                TextFormField(
                  controller:
                      descriptionController,

                  enabled: !_saving,

                  maxLines: 4,

                  decoration:
                      _inputDecoration(
                    "Descripción del problema",
                    Icons.description,
                  ),

                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return "Campo requerido";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // FECHA Y HORA
                // ==================================================

                InkWell(
                  onTap: _saving
                      ? null
                      : _pickDateTime,

                  borderRadius:
                      BorderRadius.circular(16),

                  child: Container(
                    width: double.infinity,

                    padding:
                        const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),

                      borderRadius:
                          BorderRadius.circular(16),
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.blue,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            scheduledDateTime ==
                                    null
                                ? "Fecha y hora programada"
                                : DateFormat(
                                    "dd/MM/yyyy HH:mm",
                                  ).format(
                                    scheduledDateTime!,
                                  ),

                            style: TextStyle(
                              fontWeight:
                                  FontWeight.w600,

                              color:
                                  scheduledDateTime ==
                                          null
                                      ? Colors.black45
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // BOTÓN
                // ==================================================

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed:
                        _saving
                            ? null
                            : _saveMaintenance,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF5489D9),

                      foregroundColor:
                          Colors.white,

                      disabledBackgroundColor:
                          Colors.grey[400],

                      disabledForegroundColor:
                          Colors.white,

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 16,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),

                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,

                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isEdit
                                ? "ACTUALIZAR MANTENIMIENTO"
                                : "CREAR MANTENIMIENTO",

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TÍTULO
  // ============================================================

  Widget _title(String text) {
    return Row(
      children: [
        const Icon(
          Icons.build,
          color: Colors.blue,
        ),

        const SizedBox(width: 8),

        Flexible(
          child: Text(
            text,

            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),

            maxLines: 2,

            overflow:
                TextOverflow.ellipsis,

            textAlign:
                TextAlign.center,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(icon),

      filled: true,

      fillColor:
          const Color(0xFFF8FAFC),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),

        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(16),

        borderSide:
            BorderSide.none,
      ),
    );
  }
}
