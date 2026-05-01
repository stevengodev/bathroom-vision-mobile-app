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
  State<MaintenanceFormPage>
      createState() =>
          _MaintenanceFormPageState();
}

class _MaintenanceFormPageState
    extends State<
        MaintenanceFormPage> {
  final _formKey =
      GlobalKey<FormState>();

  int? selectedBathroomId;

  final technicianController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  DateTime?
      scheduledDateTime;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<
              BathroomProvider>()
          .loadAllBathrooms();
    });

    if (widget.maintenance !=
        null) {
      final m =
          widget.maintenance!;

      selectedBathroomId =
          m.bathroom.id;

      technicianController
          .text = m
              .technicianFullName;

      descriptionController
          .text =
          m.description;
    }
  }

  Future<void>
      _pickDateTime() async {
    final date =
        await showDatePicker(
      context: context,
      firstDate:
          DateTime.now(),
      lastDate:
          DateTime(
        2035,
      ),
      initialDate:
          DateTime.now(),
    );

    if (date == null) return;

    final time =
        await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      scheduledDateTime =
          DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(
      BuildContext context) {
    final bathrooms =
        context
            .watch<
                BathroomProvider>()
            .bathrooms;

    final isEdit =
        widget.maintenance !=
            null;

    return Scaffold(
      backgroundColor:
          const Color(
        0xFFF4F6FA,
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            Colors.white,
        iconTheme:
            const IconThemeData(
          color:
              Colors.black,
        ),
        title: Text(
          isEdit
              ? "Editar ticket"
              : "Nuevo ticket",
          style:
              const TextStyle(
            color:
                Colors.black,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Form(
          key: _formKey,
          child: Container(
            padding:
                const EdgeInsets.all(
              18,
            ),
            decoration:
                BoxDecoration(
              color:
                  Colors.white,
              borderRadius:
                  BorderRadius.circular(
                24,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors
                      .black
                      .withOpacity(
                          0.05),
                  blurRadius:
                      14,
                  offset:
                      const Offset(
                    0,
                    8,
                  ),
                ),
              ],
            ),
            child: Column(
              children: [
                _title(
                  "Información del mantenimiento",
                ),

                const SizedBox(
                    height:
                        20),

                DropdownButtonFormField<
                    int>(
                  value:
                      selectedBathroomId,
                  decoration:
                      _inputDecoration(
                    "Baño",
                    Icons
                        .bathroom,
                  ),
                  items: bathrooms
                      .map(
                        (
                          b,
                        ) =>
                            DropdownMenuItem(
                          value:
                              b.id,
                          child:
                              Text(
                            "${b.nameBlock} - Piso ${b.floor}",
                          ),
                        ),
                      )
                      .toList(),
                  onChanged:
                      (
                    value,
                  ) {
                    setState(() {
                      selectedBathroomId =
                          value;
                    });
                  },
                  validator:
                      (
                    value,
                  ) {
                    if (value ==
                        null) {
                      return "Selecciona un baño";
                    }
                    return null;
                  },
                ),

                const SizedBox(
                    height:
                        16),

                TextFormField(
                  controller:
                      technicianController,
                  decoration:
                      _inputDecoration(
                    "Técnico asignado",
                    Icons.person,
                  ),
                  validator:
                      (
                    value,
                  ) {
                    if (value ==
                            null ||
                        value
                            .trim()
                            .isEmpty) {
                      return "Campo requerido";
                    }
                    return null;
                  },
                ),

                const SizedBox(
                    height:
                        16),

                TextFormField(
                  controller:
                      descriptionController,
                  maxLines:
                      4,
                  decoration:
                      _inputDecoration(
                    "Descripción del problema",
                    Icons
                        .description,
                  ),
                  validator:
                      (
                    value,
                  ) {
                    if (value ==
                            null ||
                        value
                            .trim()
                            .isEmpty) {
                      return "Campo requerido";
                    }
                    return null;
                  },
                ),

                const SizedBox(
                    height:
                        16),

                InkWell(
                  onTap:
                      _pickDateTime,
                  borderRadius:
                      BorderRadius.circular(
                    16,
                  ),
                  child:
                      Container(
                    width: double
                        .infinity,
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                    decoration:
                        BoxDecoration(
                      border:
                          Border.all(
                        color: Colors
                            .black12,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                    child:
                        Row(
                      children: [
                        const Icon(
                          Icons
                              .calendar_month,
                          color: Colors
                              .blue,
                        ),
                        const SizedBox(
                            width:
                                12),
                        Expanded(
                          child:
                              Text(
                            scheduledDateTime ==
                                    null
                                ? "Fecha y hora programada"
                                : DateFormat(
                                    "dd/MM/yyyy HH:mm",
                                  ).format(
                                    scheduledDateTime!,
                                  ),
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.w600,
                              color: scheduledDateTime ==
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

                const SizedBox(
                    height:
                        28),

                SizedBox(
                  width: double
                      .infinity,
                  child:
                      ElevatedButton(
                    onPressed:
                        () async {
                      if (!_formKey
                          .currentState!
                          .validate()) {
                        return;
                      }

                      if (scheduledDateTime ==
                          null) {
                        ScaffoldMessenger.of(
                                context)
                            .showSnackBar(
                          const SnackBar(
                            content:
                                Text(
                              "Selecciona fecha programada",
                            ),
                          ),
                        );
                        return;
                      }

                      final provider =
                          context.read<
                              MaintenanceProvider>();

                      final request =
                          MaintenanceRequest(
                        bathroomId:
                            selectedBathroomId!,
                        technicianFullName:
                            technicianController.text,
                        description:
                            descriptionController.text,
                        scheduledAt:
                            scheduledDateTime!
                                .toIso8601String(),
                      );

                      if (isEdit) {
                        await provider
                            .updateMaintenance(
                          widget
                              .maintenance!
                              .id,
                          request,
                        );
                      } else {
                        await provider
                            .createMaintenance(
                          request,
                        );
                      }

                      if (mounted) {
                        Navigator.pop(
                          context,
                          true,
                        );
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF5489D9,
                      ),
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical:
                            16,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                    child: Text(
                      isEdit
                          ? "ACTUALIZAR TICKET"
                          : "CREAR TICKET",
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

  Widget _title(
      String text) {
    return Row(
      children: [
        const Icon(
          Icons.build,
          color:
              Colors.blue,
        ),
        const SizedBox(
            width: 8),
        Text(
          text,
          style:
              const TextStyle(
            fontSize:
                18,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }

  InputDecoration
      _inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon:
          Icon(icon),
      filled: true,
      fillColor:
          const Color(
        0xFFF8FAFC,
      ),
      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        borderSide:
            BorderSide.none,
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        borderSide:
            BorderSide.none,
      ),
    );
  }
}