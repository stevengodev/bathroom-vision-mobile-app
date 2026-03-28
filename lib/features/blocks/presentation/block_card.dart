import 'package:bathroom_vision/features/blocks/models/block_response.dart';
import 'package:flutter/material.dart';

class BlockCard extends StatelessWidget {
  final BlockResponse block;
  final VoidCallback onTap;

  const BlockCard({
    super.key,
    required this.block,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8D4D4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              block.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${block.numberOfFloors} PISOS - ${block.numberOfBathrooms} BAÑOS REGISTRADOS',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}