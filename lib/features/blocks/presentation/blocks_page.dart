import 'package:bathroom_vision/features/blocks/models/block_request.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BlocksPage extends StatefulWidget {

  const BlocksPage({super.key});

  @override
  State<BlocksPage> createState() => _BlocksPageState();
}

class _BlocksPageState extends State<BlocksPage> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<BlocksProvider>().loadBlocks();
    });
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<BlocksProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bloques"),
      ),

      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.blocks.length,
              itemBuilder: (context, index) {

                final block = provider.blocks[index];

                return ListTile(
                  title: Text(block.name),
                  subtitle: Text("Pisos: ${block.numberOfFloors}"),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      provider.deleteBlock(block.id);
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          provider.createBlock(BlockRequest(name: "Bloque A", numberOfFloors: 2));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}