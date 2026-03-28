import 'package:bathroom_vision/features/blocks/presentation/blocks_provider.dart';
import 'package:bathroom_vision/shared/enums/bathroom_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveFiltersChips extends StatelessWidget {
  final BathroomStatus? status;
  final int? blockId;
  final VoidCallback onClearStatus;
  final VoidCallback onClearBlock;

  const ActiveFiltersChips({super.key, 
    this.status,
    this.blockId,
    required this.onClearStatus,
    required this.onClearBlock,
  });

  @override
  Widget build(BuildContext context) {
    if (status == null && blockId == null) return const SizedBox();

    return Consumer<BlocksProvider>(
      builder: (context, blocksProvider, _) {
        String getBlockName(int id) {
          final block = blocksProvider.blocks
              .where((b) => b.id == id)
              .toList();

          return block.isNotEmpty ? block.first.name : 'Desconocido';
        }

        return Wrap(
          spacing: 8,
          children: [
            if (status != null)
              Chip(
                label: Text('Estado: ${status!.toDisplayString()}'),
                onDeleted: onClearStatus,
              ),
            if (blockId != null)
              Chip(
                label: Text('Bloque: ${getBlockName(blockId!)}'),
                onDeleted: onClearBlock,
              ),
          ],
        );
      },
    );
  }
}