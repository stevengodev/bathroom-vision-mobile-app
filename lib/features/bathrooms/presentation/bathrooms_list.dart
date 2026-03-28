import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_card.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_provider.dart';
import 'package:bathroom_vision/shared/widgets/error_flash_card.dart';
import 'package:flutter/material.dart';

class BathroomsList extends StatelessWidget {
  final BathroomProvider provider;
  final Function() onRetry;
  final Function() onClear;

  const BathroomsList({super.key, 
    required this.provider,
    required this.onRetry,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ErrorFlashCard.error(
          context,
          message: provider.error!,
          actionLabel: 'Reintentar',
          onAction: onRetry,
        );
      });

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(provider.error!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (provider.bathrooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64),
            const SizedBox(height: 16),
            const Text('No se encontraron baños'),
            TextButton(onPressed: onClear, child: const Text('Limpiar filtros')),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: provider.bathrooms.length,
      itemBuilder: (_, i) {
        final b = provider.bathrooms[i];
        return BathroomCard(
          bathroom: b,
          statusColor: Colors.green, 
          onTap: () {},
        );
      },
    );
  }
}