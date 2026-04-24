import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/maintenances/presentation/maintenance_provider.dart';
import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_form_page.dart';

class MaintenanceListPage extends StatefulWidget {
  const MaintenanceListPage({super.key});

  @override
  State<MaintenanceListPage> createState() => _MaintenanceListPageState();
}

class _MaintenanceListPageState extends State<MaintenanceListPage> {
  String search = "";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<MaintenanceProvider>().loadMaintenances();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MaintenanceProvider>();

    final filtered = provider.maintenances.where((m) {
      final text = search.toLowerCase();

      final description = (m.description ?? "").toLowerCase();
      final technician = (m.technicianFullName ?? "").toLowerCase();

      return description.contains(text) || technician.contains(text);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      appBar: AppBar(
        title: const Text(
          "Mantenimientos",
          style: TextStyle(
            color: Colors.white,      
            fontWeight: FontWeight.bold, 
            fontSize: 20,              
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 84, 137, 217),
        centerTitle: true,
      ),

      body: Column(
        children: [
         
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar mantenimiento...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => search = value);
              },
            ),
          ),

        
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                    ? Center(child: Text(provider.error!))
                    : filtered.isEmpty
                        ? _emptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final m = filtered[index];
                              return _maintenanceCard(context, m);
                            },
                          ),
          ),
        ],
      ),

      
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 84, 137, 217),
        onPressed: () => _goToForm(context, null),
        child: const Icon(Icons.add, size: 28, color: Colors.white,),
      ),
    );
  }

  Widget _maintenanceCard(BuildContext context, MaintenanceResponse m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: const Border(
          left: BorderSide(
            color: Color.fromARGB(255, 12, 90, 6),
            width: 5,
          ),
        ),
      ),
      child: Row(
        children: [
          /// ICONO
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.build, color: Color.fromARGB(255, 12, 90, 6)),
          ),

          const SizedBox(width: 14),

          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person, size: 14, color: Colors.black26),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        m.technicianFullName,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

     
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black45),
                onPressed: () => _goToForm(context, m),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _confirmDelete(context, m),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, MaintenanceResponse m) {
    final provider = context.read<MaintenanceProvider>();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Eliminar mantenimiento"),
          content: Text("¿Eliminar \"${m.description}\"?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await provider.delete(m.id);
                await provider.loadMaintenances();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Eliminado correctamente")),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _goToForm(BuildContext context, MaintenanceResponse? m) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MaintenanceFormPage(maintenance: m),
      ),
    );

    context.read<MaintenanceProvider>().loadMaintenances();
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build_circle_outlined, size: 60, color: Colors.black12),
          SizedBox(height: 12),
          Text(
            "No hay mantenimientos",
            style: TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}