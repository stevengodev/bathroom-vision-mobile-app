import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/bathrooms/models/bathroom_response.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_card.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_provider.dart';
import 'package:bathroom_vision/shared/enums/bathroom_status.dart';

class BathroomStatusPage extends StatefulWidget {
  final BathroomResponse bathroom;

  const BathroomStatusPage({super.key, required this.bathroom});

  @override
  State<BathroomStatusPage> createState() => _BathroomStatusPageState();
}

class _BathroomStatusPageState extends State<BathroomStatusPage> {
  late BathroomStatus selectedStatus;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.bathroom.status;
  }

  Color _getStatusColor(BathroomStatus status) {
    switch (status) {
      case BathroomStatus.DISPONIBLE:
        return Colors.green;
      case BathroomStatus.EN_LIMPIEZA:
        return Colors.orange;
      case BathroomStatus.EN_MANTENIMIENTO:
        return Colors.yellow[700]!;
      case BathroomStatus.FUERA_DE_SERVICIO:
        return Colors.red;
    }
  }

  Future<void> _updateStatus() async {
    setState(() => loading = true);

    try {
      await context.read<BathroomProvider>().updateBathroomStatus(
            widget.bathroom.id,
            selectedStatus.name,
          );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bathroom = widget.bathroom;

    return Scaffold(
      appBar: AppBar(title: const Text("Cambiar estado")),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tarjeta del baño
            BathroomCard(
              bathroom: bathroom,
              statusColor: _getStatusColor(selectedStatus),
              onTap: () {},
            ),

            const SizedBox(height: 20),

            // Lista de estados
            Expanded(
              child: ListView(
                children: BathroomStatus.values.map((status) {
                  final isSelected = status == selectedStatus;

                  return _statusButton(
                    text: status.toDisplayString(),
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => selectedStatus = status);
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _updateStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("ACTUALIZAR ESTADO"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Botón estilo Duolingo (como tu imagen)
  Widget _statusButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}