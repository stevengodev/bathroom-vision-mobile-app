import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_card.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_detail_page.dart';
import 'package:bathroom_vision/features/bathrooms/presentation/bathroom_form_page.dart';
import 'package:bathroom_vision/features/blocks/presentation/blocks_provider.dart';
import 'package:bathroom_vision/shared/enums/bathroom_status.dart';
import 'package:bathroom_vision/shared/enums/gender.dart';
import 'package:bathroom_vision/shared/widgets/filter_chip_widget.dart';
import 'package:bathroom_vision/shared/widgets/gender_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bathroom_provider.dart';

class BathroomsPage extends StatefulWidget {
  const BathroomsPage({super.key});

  @override
  State<BathroomsPage> createState() => _BathroomsPageState();
}

class _BathroomsPageState extends State<BathroomsPage> {
  final TextEditingController _searchController = TextEditingController();

  // Filtros locales de UI (para mostrar selección)
  String _selectedGenderUI = 'Todos'; // UI: Todos, Hombres, Mujer, Unisex
  BathroomStatus? _selectedStatus; // Backend: DISPONIBLE, EN_LIMPIEZA, etc.
  int? _selectedBlockId;

  @override
  void initState() {
    super.initState();
    // Cargar baños y bloques al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BathroomProvider>().loadAllBathrooms();
      context.read<BlocksProvider>().loadBlocks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Convierte selección de UI a enum de backend
  Gender? _getGenderFromUI(String genderUI) {
    switch (genderUI) {
      case 'Hombres':
        return Gender.MASCULINO;
      case 'Mujer':
        return Gender.FEMENINO;
      case 'Unisex':
        return Gender.UNISEX;
      default:
        return null; // "Todos" = sin filtro
    }
  }

  void _goToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const BathroomFormPage(), // 👈 debes tener esta pantalla
      ),
    );

    if (result != null) {
      context.read<BathroomProvider>().loadAllBathrooms();
    }
  }

  /// Aplicar filtros al provider
  void _applyFilters() {
    final provider = context.read<BathroomProvider>();

    provider.searchBathrooms(
      gender: _getGenderFromUI(_selectedGenderUI),
      status: _selectedStatus,
      blockId: _selectedBlockId,
      query: _searchController.text.isEmpty ? null : _searchController.text,
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedGenderUI = 'Todos';
      _selectedStatus = null;
      _selectedBlockId = null;
      _searchController.clear();
    });

    context.read<BathroomProvider>().clearFilters();
  }

  void _showFilterMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filtros adicionales',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Filtro por Estado
              const Text(
                'Estado',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChipWidget(
                    label: 'Todos',
                    isSelected: _selectedStatus == null,
                    onTap: () {
                      setModalState(() => _selectedStatus = null);
                      setState(() => _selectedStatus = null);
                    },
                  ),
                  FilterChipWidget(
                    label: 'Disponible',
                    isSelected: _selectedStatus == BathroomStatus.DISPONIBLE,
                    onTap: () {
                      setModalState(
                        () => _selectedStatus = BathroomStatus.DISPONIBLE,
                      );
                      setState(
                        () => _selectedStatus = BathroomStatus.DISPONIBLE,
                      );
                    },
                  ),
                  FilterChipWidget(
                    label: 'Limpieza',
                    isSelected: _selectedStatus == BathroomStatus.EN_LIMPIEZA,
                    onTap: () {
                      setModalState(
                        () => _selectedStatus = BathroomStatus.EN_LIMPIEZA,
                      );
                      setState(
                        () => _selectedStatus = BathroomStatus.EN_LIMPIEZA,
                      );
                    },
                  ),
                  FilterChipWidget(
                    label: 'Mantenimiento',
                    isSelected:
                        _selectedStatus == BathroomStatus.EN_MANTENIMIENTO,
                    onTap: () {
                      setModalState(
                        () => _selectedStatus = BathroomStatus.EN_MANTENIMIENTO,
                      );
                      setState(
                        () => _selectedStatus = BathroomStatus.EN_MANTENIMIENTO,
                      );
                    },
                  ),
                  FilterChipWidget(
                    label: 'Fuera de servicio',
                    isSelected:
                        _selectedStatus == BathroomStatus.FUERA_DE_SERVICIO,
                    onTap: () {
                      setModalState(
                        () =>
                            _selectedStatus = BathroomStatus.FUERA_DE_SERVICIO,
                      );
                      setState(
                        () =>
                            _selectedStatus = BathroomStatus.FUERA_DE_SERVICIO,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Filtro por Bloque (aquí debes cargar bloques desde tu BlocksProvider)
              const Text(
                'Bloque',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Consumer<BlocksProvider>(
                builder: (context, blocksProvider, _) {
                  if (blocksProvider.loading) {
                    return const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Wrap(
                    spacing: 8,
                    children: [
                      // "Todos"
                      FilterChipWidget(
                        label: 'Todos',
                        isSelected: _selectedBlockId == null,
                        onTap: () {
                          setModalState(() => _selectedBlockId = null);
                          setState(() => _selectedBlockId = null);
                        },
                      ),

                      // Dinámicos
                      ...blocksProvider.blocks.map((block) {
                        return FilterChipWidget(
                          label: block.name,
                          isSelected: _selectedBlockId == block.id,
                          onTap: () {
                            setModalState(() => _selectedBlockId = block.id);
                            setState(() => _selectedBlockId = block.id);
                          },
                        );
                      }),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _clearFilters();
                        setModalState(() {
                          _selectedStatus = null;
                          _selectedBlockId = null;
                        });
                      },
                      child: const Text('Limpiar filtros'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _applyFilters();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8FD99F),
                      ),
                      child: const Text('Aplicar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

  String _getBlockName(int blockId) {
    final blocksProvider = context.read<BlocksProvider>();

    try {
      final block = blocksProvider.blocks.firstWhere((b) => b.id == blockId);
      return block.name;
    } catch (e) {
      return 'Bloque desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bathroomProvider = context.watch<BathroomProvider>();
    final hasActiveFilters =
        _selectedStatus != null || _selectedBlockId != null;

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
                'Baños',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 16),

            // Búsqueda y filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => _applyFilters(),
                      decoration: InputDecoration(
                        hintText: 'Buscar',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: _showFilterMenu,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                      if (hasActiveFilters)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Filtros de género
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GenderFilterButton(
                    label: 'Todos',
                    isSelected: _selectedGenderUI == 'Todos',
                    onTap: () {
                      setState(() => _selectedGenderUI = 'Todos');
                      _applyFilters();
                    },
                  ),
                  const SizedBox(width: 8),
                  GenderFilterButton(
                    label: 'Hombres',
                    isSelected: _selectedGenderUI == 'Hombres',
                    onTap: () {
                      setState(() => _selectedGenderUI = 'Hombres');
                      _applyFilters();
                    },
                  ),
                  const SizedBox(width: 8),
                  GenderFilterButton(
                    label: 'Mujer',
                    isSelected: _selectedGenderUI == 'Mujer',
                    onTap: () {
                      setState(() => _selectedGenderUI = 'Mujer');
                      _applyFilters();
                    },
                  ),
                  const SizedBox(width: 8),
                  GenderFilterButton(
                    label: 'Unisex',
                    isSelected: _selectedGenderUI == 'Unisex',
                    onTap: () {
                      setState(() => _selectedGenderUI = 'Unisex');
                      _applyFilters();
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Chips de filtros activos
            if (hasActiveFilters)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (_selectedStatus != null)
                      Chip(
                        label: Text(
                          'Estado: ${_selectedStatus!.toDisplayString()}',
                        ),
                        onDeleted: () {
                          setState(() => _selectedStatus = null);
                          _applyFilters();
                        },
                      ),
                    if (_selectedBlockId != null)
                      Chip(
                        label: Text(_getBlockName(_selectedBlockId!)),
                        onDeleted: () {
                          setState(() => _selectedBlockId = null);
                          _applyFilters();
                        },
                      ),
                  ],
                ),
              ),

            if (hasActiveFilters) const SizedBox(height: 8),

            // Lista de baños
            Expanded(
              child: bathroomProvider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : bathroomProvider.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(bathroomProvider.error!),
                          TextButton(
                            onPressed: () =>
                                bathroomProvider.loadAllBathrooms(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    )
                  : bathroomProvider.bathrooms.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No se encontraron baños',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: _clearFilters,
                            child: const Text('Limpiar filtros'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: bathroomProvider.bathrooms.length,
                      itemBuilder: (context, index) {
                        final bathroom = bathroomProvider.bathrooms[index];
                        return BathroomCard(
                          bathroom: bathroom,
                          statusColor: _getStatusColor(bathroom.status),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BathroomDetailPage(bathroom: bathroom),
                              ),
                            );
                          },
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
