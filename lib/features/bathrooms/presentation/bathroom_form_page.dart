import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/bathrooms/models/bathroom_request.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_provider.dart';
import 'package:bathroom_vision/features/blocks/models/block_response.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_provider.dart';
import 'package:bathroom_vision/shared/enums/bathroom_status.dart';
import 'package:bathroom_vision/shared/enums/gender.dart';

class BathroomFormPage extends StatefulWidget {
  final int? id;
  final BathroomRequest? bathroom;

  const BathroomFormPage({super.key, this.id, this.bathroom});

  @override
  State<BathroomFormPage> createState() => _BathroomFormPageState();
}

class _BathroomFormPageState extends State<BathroomFormPage> {
  Gender? selectedGender;
  BathroomStatus? selectedStatus;
  int? selectedBlockId;
  int? selectedFloor;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    // 🔥 Precargar datos si es edición
    selectedGender = widget.bathroom?.gender;
    selectedStatus = widget.bathroom?.status;
    selectedBlockId = widget.bathroom?.blockId;
    selectedFloor = widget.bathroom?.floor;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlocksProvider>().loadBlocks();
    });
  }

  Future<void> _save() async {
    if (selectedGender == null ||
        selectedStatus == null ||
        selectedBlockId == null ||
        selectedFloor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    setState(() => loading = true);

    final request = BathroomRequest(
      gender: selectedGender!,
      blockId: selectedBlockId!,
      status: selectedStatus!,
      floor: selectedFloor!,
    );

    try {
      if (widget.bathroom == null) {
        // CREAR
        await context.read<BathroomProvider>().createBathroom(request);
      } else {
        // EDITAR
        await context.read<BathroomProvider>().updateBathroom(
          widget.id!,
          request,
        );
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocksProvider = context.watch<BlocksProvider>();
    final isEditing = widget.bathroom != null;

    // Obtener bloque seleccionado de forma segura
    BlockResponse? selectedBlock;
    if (selectedBlockId != null) {
      try {
        selectedBlock = blocksProvider.blocks.firstWhere(
          (b) => b.id == selectedBlockId,
        );
      } catch (_) {}
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Editar Baño" : "Nuevo Baño")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // GÉNERO
            BathroomDropdown<Gender>(
              label: "Género",
              initialValue: selectedGender,
              items: Gender.values,
              getLabel: (g) => g.name,
              onChanged: (v) => setState(() => selectedGender = v),
            ),

            const SizedBox(height: 16),

            // ESTADO
            BathroomDropdown<BathroomStatus>(
              label: "Estado",
              initialValue: selectedStatus,
              items: BathroomStatus.values,
              getLabel: (s) => s.name,
              onChanged: (v) => setState(() => selectedStatus = v),
            ),

            const SizedBox(height: 16),

            // BLOQUE
            blocksProvider.loading
                ? const CircularProgressIndicator()
                : BathroomDropdown<int>(
                    label: "Bloque",
                    initialValue: selectedBlockId,
                    items: blocksProvider.blocks.map((b) => b.id).toList(),
                    getLabel: (id) => blocksProvider.blocks
                        .firstWhere((b) => b.id == id)
                        .name,
                    onChanged: (v) {
                      setState(() {
                        selectedBlockId = v;
                        selectedFloor = null; // reset piso al cambiar bloque
                      });
                    },
                  ),

            const SizedBox(height: 16),

            // PISO (DEPENDIENTE)
            BathroomDropdown<int>(
              label: "Piso",
              initialValue: selectedFloor,
              items: selectedBlock == null
                  ? []
                  : List.generate(
                      selectedBlock.numberOfFloors,
                      (index) => index + 1,
                    ),
              getLabel: (f) => "Piso $f",
              onChanged: selectedBlock == null
                  ? null // deshabilitado hasta elegir bloque
                  : (v) => setState(() => selectedFloor = v),
            ),

            const SizedBox(height: 24),

            // BOTÓN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8FD99F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(isEditing ? "ACTUALIZAR" : "GUARDAR"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
