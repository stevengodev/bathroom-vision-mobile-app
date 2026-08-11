
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

  const BlockDetailPage({
    super.key,
    required this.block,
  });

  // ============================================================
  // ELIMINAR BLOQUE
  // ============================================================

  void _delete(BuildContext context) async {
    // ============================================================
    // PRIMERA VALIDACIÓN:
    // VERIFICAR SI EL BLOQUE TIENE BAÑOS ASOCIADOS
    // ============================================================

    if (block.bathrooms > 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "No se puede eliminar este bloque porque tiene baños asociados.",
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );

      return;
    }

    // ============================================================
    // SI NO TIENE BAÑOS:
    // PEDIR CONFIRMACIÓN
    // ============================================================

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text("Eliminar bloque"),
          ],
        ),
        content: Text(
          "¿Estás seguro de que quieres eliminar ${block.name}?\n\n"
          "Esta acción no se puede deshacer.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              "Eliminar",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    // ============================================================
    // SI CANCELÓ
    // ============================================================

    if (confirm != true) {
      return;
    }

    // ============================================================
    // ELIMINAR BLOQUE
    // ============================================================

    try {
      final provider = Provider.of<BlocksProvider>(
        context,
        listen: false,
      );

      await provider.deleteBlock(block.id);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "Bloque eliminado correctamente.",
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Regresar a la lista de bloques
      Navigator.pushNamed(context, '/blocks');
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              "No se pudo eliminar el bloque: $e",
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
    }
  }

  // ============================================================
  // EDITAR BLOQUE
  // ============================================================

  void _edit(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlockFormPage(
          id: block.id,
          block: BlockRequest(
            name: block.name,
            numberOfFloors: block.floors,
          ),
        ),
      ),
    );

    if (result != null) {
      Navigator.pushNamed(context, '/blocks');
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    final isAdmin =
        userProvider.user?.role.toUpperCase() == Role.ADMIN.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(block.name),
        backgroundColor: const Color(0xFF8FD99F),
        actions: isAdmin
            ? [
                // ========================================================
                // EDITAR DESDE APPBAR
                // ========================================================

                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _edit(context),
                ),

                // ========================================================
                // ELIMINAR DESDE APPBAR
                // ========================================================

                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _delete(context),
                ),
              ]
            : null,
      ),

      // ================================================================
      // BODY
      // ================================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ==========================================================
            // TARJETA PRINCIPAL
            // ==========================================================

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

                    _buildInfoRow(
                      Icons.apartment,
                      'Bloque',
                      block.name,
                    ),

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

            // ==========================================================
            // BOTONES DE ADMINISTRADOR
            // ==========================================================

            if (isAdmin)
              Row(
                children: [
                  // ======================================================
                  // EDITAR
                  // ======================================================

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _edit(context),
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8FD99F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // ======================================================
                  // ELIMINAR
                  // ======================================================

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _delete(context),
                      icon: const Icon(Icons.delete),
                      label: const Text('Eliminar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  // ============================================================
  // FILA DE INFORMACIÓN
  // ============================================================

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[700],
        ),

        const SizedBox(width: 10),

        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
