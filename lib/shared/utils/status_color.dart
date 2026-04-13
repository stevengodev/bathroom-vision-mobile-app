  import 'package:bathroom_vision/shared/enums/bathroom_status.dart';
import 'package:flutter/material.dart';

Color getStatusColor(BathroomStatus status) {
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