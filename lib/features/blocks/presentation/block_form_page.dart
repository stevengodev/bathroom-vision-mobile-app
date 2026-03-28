import 'package:bathroom_vision/features/blocks/models/block_request.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlockFormPage extends StatefulWidget {
  final int? id;
  final BlockRequest? block;

  const BlockFormPage({super.key, this.id, this.block});

  @override
  State<BlockFormPage> createState() => _BlockFormPageState();
}

class _BlockFormPageState extends State<BlockFormPage> {
  late TextEditingController nameController;
  late TextEditingController floorsController;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.block?.name ?? '');
    floorsController = TextEditingController(
      text: widget.block?.numberOfFloors.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    floorsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (nameController.text.isEmpty) return;

    final provider = Provider.of<BlocksProvider>(context, listen: false);
    setState(() => loading = true);

    final request = BlockRequest(
      name: nameController.text,
      numberOfFloors: int.tryParse(floorsController.text) ?? 0,
    );

    try {
      if (widget.block == null) {
        // Crear nuevo bloque
        await provider.createBlock(request);
      } else {
        // Editar bloque existente
        await provider.updateBlock(widget.id!, request);
      }

      Navigator.pushNamed(context, '/blocks');
    } catch (e) {
      // Manejo de error simple
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar el bloque: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.block != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Bloque' : 'Nuevo Bloque')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInput(nameController, 'Nombre del Bloque'),
            const SizedBox(height: 16),
            _buildInput(
              floorsController,
              'Número de Pisos',
              keyboard: TextInputType.number,
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8FD99F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'GUARDAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
