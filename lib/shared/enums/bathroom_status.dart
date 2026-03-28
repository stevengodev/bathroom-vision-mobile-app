enum BathroomStatus {
  DISPONIBLE,
  EN_LIMPIEZA,
  EN_MANTENIMIENTO,
  FUERA_DE_SERVICIO;

  String toDisplayString() {
    switch (this) {
      case BathroomStatus.DISPONIBLE:
        return 'Disponible';
      case BathroomStatus.EN_LIMPIEZA:
        return 'Limpieza';
      case BathroomStatus.EN_MANTENIMIENTO:
        return 'Mantenimiento';
      case BathroomStatus.FUERA_DE_SERVICIO:
        return 'Fuera de servicio';
    }
  }

}
