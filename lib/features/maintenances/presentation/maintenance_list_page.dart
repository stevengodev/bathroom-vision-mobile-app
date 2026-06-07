import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_detail_page.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_form_page.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_provider.dart';

class MaintenanceListPage extends StatefulWidget {
  const MaintenanceListPage({super.key});

  @override
  State<MaintenanceListPage> createState() =>
      _MaintenanceListPageState();
}

class _MaintenanceListPageState extends State<MaintenanceListPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaintenanceProvider>().loadMaintenances();
    });
  }

  Future<void> _goToCreate() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MaintenanceFormPage(),
      ),
    );

    if (result != null) {
      context.read<MaintenanceProvider>().loadMaintenances();
    }
  }

  Future<void> _goToDetail(MaintenanceResponse maintenance) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MaintenanceDetailPage(
          maintenance: maintenance,
        ),
      ),
    );

    if (result != null) {
      context.read<MaintenanceProvider>().loadMaintenances();
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case "CERRADO":
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MaintenanceProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      // =========================
      // APPBAR CON AVATAR A LA DERECHA
      // =========================
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6FA),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFF1E293B),
        ),

        title: const Text(
          "Mantenimientos",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _goToCreate,
        backgroundColor: const Color(0xFF5489D9),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip(
                      text: "Todos",
                      selected: provider.selectedStatus == null,
                      onTap: () {
                        context.read<MaintenanceProvider>().loadMaintenances();
                      },
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      text: "Abiertos",
                      selected: provider.selectedStatus == "ABIERTO",
                      onTap: () {
                        context.read<MaintenanceProvider>().loadMaintenances(
                              status: "ABIERTO",
                            );
                      },
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      text: "Cerrados",
                      selected: provider.selectedStatus == "CERRADO",
                      onTap: () {
                        context.read<MaintenanceProvider>().loadMaintenances(
                              status: "CERRADO",
                            );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: provider.loading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.maintenances.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                          itemCount: provider.maintenances.length,
                          itemBuilder: (context, index) {
                            final item = provider.maintenances[index];
                            return _ticketCard(item);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketCard(MaintenanceResponse item) {
    final color = _statusColor(item.status);

    return InkWell(
      onTap: () => _goToDetail(item),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border(
            left: BorderSide(color: color, width: 5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.build, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.technicianFullName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.build_circle_outlined,
            size: 70,
            color: Colors.black12,
          ),
          SizedBox(height: 14),
          Text(
            "No hay mantenimientos",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black38,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _filterChip({
  required String text,
  required bool selected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: selected ? Colors.blue : Colors.black12,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: selected ? Colors.white : Colors.black87,
        ),
      ),
    ),
  );
}