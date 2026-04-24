import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_provider.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_request.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_provider.dart';

class MaintenanceFormPage extends StatefulWidget {
  final MaintenanceResponse? maintenance;

  const MaintenanceFormPage({super.key, this.maintenance});

  @override
  State<MaintenanceFormPage> createState() => _MaintenanceFormPageState();
}

class _MaintenanceFormPageState extends State<MaintenanceFormPage> {
  final _formKey = GlobalKey<FormState>();

  int? selectedBathroomId;
  final TextEditingController technicianController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<BathroomProvider>(context, listen: false)
          .loadAllBathrooms();
    });

    if (widget.maintenance != null) {
      final m = widget.maintenance!;
      selectedBathroomId = m.bathroom.id;
      technicianController.text = m.technicianFullName;
      descriptionController.text = m.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bathroomProvider = Provider.of<BathroomProvider>(context);
    final bathrooms = bathroomProvider.bathrooms;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.maintenance == null
              ? "Crear mantenimiento"
              : "Editar mantenimiento",
        ),
      ),

      /// 🔥 SOLUCIÓN AQUÍ
      body: SingleChildScrollView(
        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag, // opcional PRO
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                initialValue: selectedBathroomId,
                decoration: const InputDecoration(
                  labelText: "Selecciona baño",
                ),
                items: bathrooms.map((b) {
                  return DropdownMenuItem(
                    value: b.id,
                    child: Text(
                      "${b.nameBlock} - Piso ${b.floor} - ${b.gender.name}",
                    ),
                  );
                }).toList(),
                onChanged: (v) => setState(() => selectedBathroomId = v),
                validator: (v) =>
                    v == null ? "Selecciona un baño" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: technicianController,
                decoration: const InputDecoration(
                  labelText: "Nombre del técnico",
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? "Campo requerido" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Descripción",
                ),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? "Campo requerido" : null,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final provider =
                        Provider.of<MaintenanceProvider>(context, listen: false);

                    final request = MaintenanceRequest(
                      bathroomId: selectedBathroomId!,
                      technicianFullName: technicianController.text,
                      description: descriptionController.text,
                    );

                    if (widget.maintenance == null) {
                      await provider.create(request);
                    } else {
                      await provider.update(
                        widget.maintenance!.id,
                        request,
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.maintenance == null
                              ? "Creado correctamente"
                              : "Actualizado correctamente",
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  },
                  child: Text(
                    widget.maintenance == null ? "Crear" : "Actualizar",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}