import 'package:bathroom_vision/features/auth/presentation/user_provider.dart';
import 'package:bathroom_vision/features/blocks/models/block_request.dart';
import 'package:bathroom_vision/features/blocks/models/block_response.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_provider.dart';
import 'package:bathroom_vision/shared/enums/role.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'block_form_page.dart';

class BlockDetailPage extends StatelessWidget {
  final BlockResponse block;

  const BlockDetailPage({super.key, required this.block});

  void _delete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar bloque'),
        content: Text('¿Estás seguro de eliminar ${block.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final provider = Provider.of<BlocksProvider>(
                context,
                listen: false,
              );

              Navigator.pop(context); // cerrar diálogo

              await provider.deleteBlock(block.id);

              // Navigator.pop(context, true); // volver y avisar que se eliminó
              Navigator.pushNamed(context, '/blocks');
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _edit(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlockFormPage(
          id: block.id,
          block: BlockRequest(name: block.name, numberOfFloors: block.floors),
        ),
      ),
    );

    if (result != null) {
      // Navigator.pop(context, result); // Retorna datos editados
      Navigator.pushNamed(context, '/blocks');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final isAdmin = userProvider.user?.role.toUpperCase() == Role.ADMIN.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(block.name),
        backgroundColor: const Color(0xFF8FD99F),
        actions: isAdmin
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _edit(context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _delete(context),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tarjeta principal
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      Icons.perm_identity,
                      'ID',
                      block.id.toString(),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.apartment, 'Bloque', block.name),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.layers,
                      'Pisos',
                      block.floors.toString(),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.bathtub,
                      'Baños',
                      block.bathrooms.toString(),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            if (isAdmin)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _edit(context),
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8FD99F),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _delete(context),
                      icon: const Icon(Icons.delete),
                      label: const Text('Eliminar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
