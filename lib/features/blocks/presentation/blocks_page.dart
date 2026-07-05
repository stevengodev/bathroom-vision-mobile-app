import 'package:bathroom_vision/features/blocks/models/block_response.dart';
import 'package:bathroom_vision/features/blocks/presentation/block_card.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'block_detail_page.dart';
import 'block_form_page.dart';

class BlocksPage extends StatefulWidget {
  const BlocksPage({super.key});

  @override
  State<BlocksPage> createState() => _BlocksPageState();
}

class _BlocksPageState extends State<BlocksPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar bloques al iniciar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BlocksProvider>(context, listen: false).loadBlocks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const BlockFormPage(),
      ),
    );

    if (result != null) {
      // Después de crear un bloque, recargamos la lista desde el provider
      Provider.of<BlocksProvider>(context, listen: false).loadBlocks();
    }
  }

  void _goToDetail(BlockResponse block) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlockDetailPage(block: block),
      ),
    );

    if (result != null) {
      // Si se eliminó o editó, recargamos la lista
      Provider.of<BlocksProvider>(context, listen: false).loadBlocks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BlocksProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreate,
        backgroundColor: const Color.fromARGB(255, 143, 217, 159),
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'BAÑOVISIÓN',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Gestión de bloques',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  provider.searchBlocksByName(value);
                },
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: provider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: provider.blocks.length,
                      itemBuilder: (context, index) {
                        final block = provider.blocks[index];
                        return BlockCard(
                          block: block,
                          onTap: () => _goToDetail(block),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}