import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bathroom_vision/features/maintenances/models/maintenance_response.dart';
import 'package:bathroom_vision/features/maintenances/presentation/maintenance_provider.dart';

class MaintenanceStatusPage extends StatefulWidget {
  final MaintenanceResponse maintenance;

  const MaintenanceStatusPage({
    super.key,
    required this.maintenance,
  });

  @override
  State<MaintenanceStatusPage> createState() =>
      _MaintenanceStatusPageState();
}

class _MaintenanceStatusPageState
    extends State<MaintenanceStatusPage> {
  late String selectedStatus;

  bool loading = false;

  @override
  void initState() {
    super.initState();

    selectedStatus =
        widget.maintenance.status;
  }

  Color _getStatusColor(
      String status) {
    switch (status) {
      case "CERRADO":
        return Colors.green;  
      case "ABIERTO":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Future<void> _updateStatus()
  async {
    setState(() {
      loading = true;
    });

    try {
      await context
          .read<
              MaintenanceProvider>()
          .updateMaintenanceStatus(
            widget.maintenance.id,
            selectedStatus,
          );

      if (mounted) {
        Navigator.pop(
          context,
          true,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(
      BuildContext context) {
    final maintenance =
        widget.maintenance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cambiar estado",
        ),
        backgroundColor:
            const Color.fromARGB(
          255,
          84,
          137,
          217,
        ),
      ),
      backgroundColor:
          Colors.grey[100],
      body: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [
            /// TARJETA
            Container(
              width:
                  double.infinity,
              padding:
                  const EdgeInsets
                      .all(18),
              decoration:
                  BoxDecoration(
                color:
                    Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  22,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors
                        .black
                        .withOpacity(
                            0.05),
                    blurRadius:
                        12,
                    offset:
                        const Offset(
                            0, 8),
                  ),
                ],
                border:
                    Border(
                  left:
                      BorderSide(
                    color:
                        _getStatusColor(
                      selectedStatus,
                    ),
                    width:
                        5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width:
                        50,
                    height:
                        50,
                    decoration:
                        BoxDecoration(
                      color: _getStatusColor(
                              selectedStatus)
                          .withOpacity(
                              0.15),
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                    child: Icon(
                      Icons.build,
                      color:
                          _getStatusColor(
                        selectedStatus,
                      ),
                    ),
                  ),

                  const SizedBox(
                      width: 14),

                  Expanded(
                    child:
                        Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          maintenance
                              .description,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize:
                                15,
                          ),
                        ),
                        const SizedBox(
                            height:
                                6),
                        Text(
                          maintenance
                              .technicianFullName,
                          style:
                              const TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
                height: 24),

            /// ESTADOS
            Expanded(
              child: ListView(
                children: [
                  _statusButton(
                    text:
                        "ABIERTO",
                    value:
                        "ABIERTO",
                  ),
                  _statusButton(
                    text:
                        "CERRADO",
                    value:
                        "CERRADO",
                  ),
                ],
              ),
            ),

            const SizedBox(
                height: 12),

            /// BOTON
            SizedBox(
              width:
                  double.infinity,
              child:
                  ElevatedButton(
                onPressed:
                    loading
                        ? null
                        : _updateStatus,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical:
                        16,
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "ACTUALIZAR ESTADO",
                        style:
                            TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusButton({
    required String text,
    required String value,
  }) {
    final isSelected =
        selectedStatus ==
            value;

    return InkWell(
      onTap: () {
        setState(() {
          selectedStatus =
              value;
        });
      },
      borderRadius:
          BorderRadius.circular(
        16,
      ),
      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 12,
        ),
        padding:
            const EdgeInsets
                .symmetric(
          vertical: 18,
        ),
        decoration:
            BoxDecoration(
          color: isSelected
              ? Colors.green[300]
              : Colors.grey[200],
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          border: Border.all(
            color: isSelected
                ? Colors.green
                : Colors
                    .grey
                    .shade400,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              color: isSelected
                  ? Colors.black
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}